//
//  ExportAppTranslationsUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import Foundation

/// The file format an app's translations can be exported to. Which ones
/// make sense depends on the app's platform - see `available(for:)`.
enum TranslationExportFormat: String, CaseIterable, Identifiable {
  /// Android `strings.xml`.
  case xml
  /// A generic nested object - also the native shape React/i18next-style
  /// projects expect.
  case json
  /// Apple's classic `.strings` table (`"key" = "value";`).
  case strings

  var id: String { rawValue }

  var label: String {
    switch self {
      case .xml: return "XML"
      case .json: return "JSON"
      case .strings: return ".strings"
    }
  }

  /// The formats worth offering for a given platform, most natural first
  /// (that first one is also what the export screen pre-selects).
  static func available(for platformId: String) -> [TranslationExportFormat] {
    switch platformId {
      case SupportedPlatforms.ANDROID.id:
        return [.xml, .json]
      case SupportedPlatforms.IOS.id:
        return [.strings, .json]
      case SupportedPlatforms.REACT.id:
        return [.json]
      default:
        return [.json]
    }
  }

  /// The default language's file carries no language suffix; every other
  /// language gets one, so exporting several languages for the same app
  /// doesn't overwrite a single shared filename. React/i18next projects
  /// key their locale files by the language code itself (`en.json`,
  /// `ar.json`) rather than this app's own `strings`/`translations` base
  /// name, so JSON exports for a React app follow that convention instead.
  func suggestedFileName(platformId: String, lang: String, isDefaultLang: Bool) -> String {
    if self == .json && platformId == SupportedPlatforms.REACT.id {
      return "\(lang).json"
    }
    let base: String
    switch self {
      case .xml: base = "strings"
      case .strings: base = "Localizable"
      case .json: base = "translations"
    }
    let suffix = isDefaultLang ? "" : "-\(lang)"
    return "\(base)\(suffix).\(rawValue)"
  }
}

/// Renders every key an app isn't excluded from - across every group in its
/// workspace, not just one - as a single-language export file. A key's
/// place in the group tree becomes part of its exported identity: a key
/// sitting directly at the workspace root exports under its own name, one
/// nested a group or more deep carries its ancestor group names with it
/// (flattened with underscores for XML, as real nested objects for JSON).
class ExportAppTranslationsUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

  func export(
    workspaceId: UUID,
    appId: UUID,
    lang: String,
    format: TranslationExportFormat
  ) async throws -> String {
    async let keysTask = repo.fetchKeysByWorkspaceId(workspaceId: workspaceId)
    async let groupsTask = repo.fetchAllGroups(workspaceId: workspaceId)
    let (allKeys, allGroups) = try await (keysTask, groupsTask)

    let groupsById = Dictionary(uniqueKeysWithValues: allGroups.map { ($0.id, $0) })
    let includedKeys = allKeys.filter { !$0.excludedApps.contains(appId) }

    let values = try await repo.fetchValues(forKeyIds: includedKeys.map { $0.id })
      .filter { $0.lang == lang }

    // Resolve the effective value per key for this app: its own override
    // if it has one, otherwise the shared default (appId == nil). Starting
    // from the defaults and then overlaying overrides on top guarantees
    // the override wins regardless of array order.
    var valueByKeyId = Dictionary(
      values.filter { $0.appId == nil }.map { ($0.keyId, $0.value) },
      uniquingKeysWith: { _, latest in latest }
    )
    for override in values where override.appId == appId {
      valueByKeyId[override.keyId] = override.value
    }

    // Keys with no translation for this language are left out rather than
    // shipped as empty strings.
    let entries: [(path: [String], value: String)] = includedKeys
      .compactMap { key -> (path: [String], value: String)? in
        guard let value = valueByKeyId[key.id], !value.isEmpty else { return nil }
        let path = Self.groupPath(forGroupId: key.groupId, groupsById: groupsById) + [key.key]
        return (path, value)
      }
      .sorted { $0.path.joined(separator: "_") < $1.path.joined(separator: "_") }

    switch format {
      case .xml:
        return Self.renderXML(entries: entries)
      case .json:
        return Self.renderJSON(entries: entries)
      case .strings:
        return Self.renderAppleStrings(entries: entries)
    }
  }

  /// Every workspace has exactly one hidden root group (parentGroupId ==
  /// nil) that keys sit in directly when they aren't inside any
  /// user-created group - it's never itself part of the exported path.
  /// Walks up from a key's immediate group to the root, collecting every
  /// other group's name along the way, then reverses to root-to-leaf order.
  private static func groupPath(
    forGroupId groupId: UUID?,
    groupsById: [UUID: TranslationGroupDTO]
  ) -> [String] {
    var segments: [String] = []
    var currentId = groupId

    while let id = currentId, let group = groupsById[id] {
      if group.parentGroupId == nil {
        // This is the hidden root container itself - stop without
        // including it.
        break
      }
      segments.append(group.key)
      currentId = group.parentGroupId
    }

    return segments.reversed()
  }

  private static func renderXML(entries: [(path: [String], value: String)]) -> String {
    var lines = ["<?xml version=\"1.0\" encoding=\"utf-8\"?>", "<resources>"]
    for entry in entries {
      let name = androidResourceName(from: entry.path)
      let value = escapeAndroidXML(entry.value)
      lines.append("    <string name=\"\(name)\">\(value)</string>")
    }
    lines.append("</resources>")
    return lines.joined(separator: "\n")
  }

  private static func renderJSON(entries: [(path: [String], value: String)]) -> String {
    var root: [String: Any] = [:]
    for entry in entries {
      insert(entry.value, at: entry.path, into: &root)
    }
    guard
      let data = try? JSONSerialization.data(
        withJSONObject: root,
        options: [.prettyPrinted, .sortedKeys]
      ),
      let json = String(data: data, encoding: .utf8)
    else {
      return "{}"
    }
    return json
  }

  /// Recursively places `value` at the nested path `["settings", "profile",
  /// "title"]` as `{"settings": {"profile": {"title": value}}}`. If a
  /// naming collision leaves something other than an object sitting where
  /// a nested level is needed, it's overwritten rather than crashing.
  private static func insert(_ value: String, at path: [String], into root: inout [String: Any]) {
    guard let head = path.first else { return }
    if path.count == 1 {
      root[head] = value
      return
    }
    var child = root[head] as? [String: Any] ?? [:]
    insert(value, at: Array(path.dropFirst()), into: &child)
    root[head] = child
  }

  /// Android string resource names only allow letters, digits and
  /// underscores, and can't start with a digit. A key's full group path -
  /// e.g. ["settings", "profile", "title"] - is flattened into one such
  /// name by sanitizing each segment and joining with underscores, since
  /// strings.xml has no notion of nesting.
  private static func androidResourceName(from path: [String]) -> String {
    let sanitizedSegments = path.map { segment -> String in
      String(segment.map { char -> Character in
        (char.isLetter || char.isNumber || char == "_") ? char : "_"
      })
    }
    var name = sanitizedSegments.joined(separator: "_")
    if let first = name.first, first.isNumber {
      name = "_" + name
    }
    return name
  }

  /// Apple's `.strings` tables have no nesting either, but unlike Android
  /// resource names their keys are just quoted strings - any character is
  /// fine, so the group path is joined with "." (the common flattened-key
  /// convention on iOS) rather than sanitized and underscored.
  private static func renderAppleStrings(entries: [(path: [String], value: String)]) -> String {
    var lines: [String] = []
    for entry in entries {
      let key = entry.path.joined(separator: ".")
      let value = escapeAppleStrings(entry.value)
      lines.append("\"\(key)\" = \"\(value)\";")
    }
    return lines.joined(separator: "\n")
  }

  private static func escapeAppleStrings(_ value: String) -> String {
    var escaped = value
    // Backslashes first, or escaping the quotes right after would double
    // up the backslash that step itself just introduced.
    escaped = escaped.replacingOccurrences(of: "\\", with: "\\\\")
    escaped = escaped.replacingOccurrences(of: "\"", with: "\\\"")
    escaped = escaped.replacingOccurrences(of: "\n", with: "\\n")
    return escaped
  }

  private static func escapeAndroidXML(_ value: String) -> String {
    var escaped = value
    escaped = escaped.replacingOccurrences(of: "&", with: "&amp;")
    escaped = escaped.replacingOccurrences(of: "<", with: "&lt;")
    escaped = escaped.replacingOccurrences(of: ">", with: "&gt;")
    escaped = escaped.replacingOccurrences(of: "\"", with: "&quot;")
    // Android treats a bare apostrophe inside a string resource as the start
    // of an escape sequence, so it needs escaping even though plain XML
    // doesn't require it.
    escaped = escaped.replacingOccurrences(of: "'", with: "\\'")
    return escaped
  }
}
