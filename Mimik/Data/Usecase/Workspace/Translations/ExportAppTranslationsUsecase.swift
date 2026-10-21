//
//  ExportAppTranslationsUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import Foundation

/// The file format an app's translations can be exported to. XML renders
/// as an Android `strings.xml`; JSON is a flat, generic key/value object.
enum TranslationExportFormat: String, CaseIterable, Identifiable {
  case xml
  case json

  var id: String { rawValue }

  var label: String {
    switch self {
      case .xml: return "XML"
      case .json: return "JSON"
    }
  }

  var suggestedFileName: String {
    switch self {
      case .xml: return "strings.xml"
      case .json: return "translations.json"
    }
  }
}

/// Renders every key an app isn't excluded from - across every group in its
/// workspace, not just one - as a single-language export file.
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
    let allKeys = try await repo.fetchKeysByWorkspaceId(workspaceId: workspaceId)
    let includedKeys = allKeys.filter { !$0.excludedApps.contains(appId) }

    let values = try await repo.fetchValues(forKeyIds: includedKeys.map { $0.id })
    let valueByKeyId = Dictionary(
      values.filter { $0.lang == lang }.map { ($0.keyId, $0.value) },
      uniquingKeysWith: { _, latest in latest }
    )

    // Keys with no translation for this language are left out rather than
    // shipped as empty strings.
    let pairs: [(key: String, value: String)] = includedKeys
      .compactMap { key -> (key: String, value: String)? in
        guard let value = valueByKeyId[key.id], !value.isEmpty else { return nil }
        return (key.key, value)
      }
      .sorted { $0.key < $1.key }

    switch format {
      case .xml:
        return Self.renderXML(pairs: pairs)
      case .json:
        return Self.renderJSON(pairs: pairs)
    }
  }

  private static func renderXML(pairs: [(key: String, value: String)]) -> String {
    var lines = ["<?xml version=\"1.0\" encoding=\"utf-8\"?>", "<resources>"]
    for pair in pairs {
      let name = androidResourceName(from: pair.key)
      let value = escapeAndroidXML(pair.value)
      lines.append("    <string name=\"\(name)\">\(value)</string>")
    }
    lines.append("</resources>")
    return lines.joined(separator: "\n")
  }

  private static func renderJSON(pairs: [(key: String, value: String)]) -> String {
    var object: [String: String] = [:]
    for pair in pairs {
      object[pair.key] = pair.value
    }
    guard
      let data = try? JSONSerialization.data(
        withJSONObject: object,
        options: [.prettyPrinted, .sortedKeys]
      ),
      let json = String(data: data, encoding: .utf8)
    else {
      return "{}"
    }
    return json
  }

  /// Android string resource names only allow letters, digits and
  /// underscores, and can't start with a digit - Mimik's own keys use dots
  /// (e.g. "login.button.title"), so this adapts one naming scheme to the
  /// other rather than producing an invalid strings.xml.
  private static func androidResourceName(from key: String) -> String {
    var characters = key.map { char -> Character in
      (char.isLetter || char.isNumber || char == "_") ? char : "_"
    }
    if let first = characters.first, first.isNumber {
      characters.insert("_", at: characters.startIndex)
    }
    return String(characters)
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
