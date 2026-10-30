//
//  EditTranslationsViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import Foundation

@Observable
class EditTranslationsViewModel {
  private let getWorkspaceUsecase: GetWorkspaceUsecase
  private let langUsecase: AddLanguageUsecase
  private let valueUsecase: TranslationValueUsecase
  private let listAppsUsecase: ListWorkspaceAppsUsecase

  init(
    getWorkspaceUsecase: GetWorkspaceUsecase,
    langUsecase: AddLanguageUsecase,
    valueUsecase: TranslationValueUsecase,
    listAppsUsecase: ListWorkspaceAppsUsecase,
  ) {
    self.getWorkspaceUsecase = getWorkspaceUsecase
    self.langUsecase = langUsecase
    self.valueUsecase = valueUsecase
    self.listAppsUsecase = listAppsUsecase
  }

  var languages: ViewState<[WSLangDTO]> = .loading()
  var workspaceApps: ViewState<[WSAppDTO]> = .loading()
  var defaultLang: String = ""
  private var values: [String: String] = [:]

  /// appId -> lang code -> override text. A lang code present here (even
  /// as "") means that app is customized for that language; absent means
  /// it falls back to `values`, the shared default.
  private var overrideValues: [UUID: [String: String]] = [:]

  /// The (appId, lang) overrides that existed when this screen loaded -
  /// used on save() to tell "still customized" apart from "customized
  /// before, reset back to default during this edit", since the latter
  /// needs an explicit delete rather than just skipping an upsert.
  private var originalOverrideKeys: Set<OverrideKey> = []

  var saveResult: ViewState<String> = .idle()

  @Published @ObservationIgnored var saveEvent: ViewEvent<AddTranslationEvents> = .none()

  struct OverrideKey: Hashable {
    let appId: UUID
    let lang: String
  }

  func value(for code: String) -> String {
    values[code] ?? ""
  }

  func setValue(_ value: String, for code: String) {
    values[code] = value
  }

  /// nil means this app isn't customized for this language - it falls
  /// back to the shared default shown by `value(for:)`.
  func overrideValue(appId: UUID, lang code: String) -> String? {
    overrideValues[appId]?[code]
  }

  func isCustomized(appId: UUID, lang code: String) -> Bool {
    overrideValues[appId]?[code] != nil
  }

  func hasAnyOverride(appId: UUID) -> Bool {
    !(overrideValues[appId]?.isEmpty ?? true)
  }

  /// Starts customizing this app+language, seeded with the current shared
  /// default as a starting point to edit from.
  func startCustomizing(appId: UUID, lang code: String) {
    overrideValues[appId, default: [:]][code] = value(for: code)
  }

  func setOverrideValue(_ value: String, appId: UUID, lang code: String) {
    overrideValues[appId, default: [:]][code] = value
  }

  /// Drops the override, reverting this app+language back to the shared
  /// default. If it was never persisted, this is simply forgotten; if it
  /// was, save() deletes the underlying row.
  func resetToDefault(appId: UUID, lang code: String) {
    overrideValues[appId]?[code] = nil
  }

  func load(workspaceId: UUID, keyId: UUID) {
    languages = .loading()
    workspaceApps = .loading()
    Task {
      do {
        async let workspaceTask = getWorkspaceUsecase.get(id: workspaceId)
        async let addedLangsTask = langUsecase.getAddedLanguages(workspaceId: workspaceId)
        async let existingValuesTask = valueUsecase.getValues(forKeyId: keyId)
        async let appsTask = listAppsUsecase.list(workspaceId: workspaceId)

        let (workspace, addedLangs, existingValues, apps) = try await (
          workspaceTask, addedLangsTask, existingValuesTask, appsTask
        )

        let activeLangs = addedLangs.values
          .filter { $0.active }
          .sorted { lhs, rhs in
            if lhs.code == workspace.defLang { return true }
            if rhs.code == workspace.defLang { return false }
            return lhs.name < rhs.name
          }

        var initialValues: [String: String] = [:]
        var initialOverrides: [UUID: [String: String]] = [:]
        var initialOverrideKeys: Set<OverrideKey> = []

        for value in existingValues {
          if let appId = value.appId {
            initialOverrides[appId, default: [:]][value.lang] = value.value
            initialOverrideKeys.insert(OverrideKey(appId: appId, lang: value.lang))
          } else {
            initialValues[value.lang] = value.value
          }
        }

        await MainActor.run {
          self.defaultLang = workspace.defLang
          self.values = initialValues
          self.overrideValues = initialOverrides
          self.originalOverrideKeys = initialOverrideKeys
          self.languages = .success(data: activeLangs)
          self.workspaceApps = .success(data: apps)
        }
      } catch {
        await MainActor.run {
          self.languages = .failure(error: "Failed to load languages for this workspace")
          self.workspaceApps = .failure(error: "Failed to load this workspace's apps")
        }
      }
    }
  }

  func save(keyId: UUID) {
    guard let langs = languages.data else { return }
    saveResult = .loading()
    Task {
      do {
        for lang in langs {
          let value = values[lang.code] ?? ""
          _ = try await valueUsecase.save(keyId: keyId, lang: lang.code, value: value)
        }

        // Per-app overrides: persist everything currently marked
        // customized, then remove any override that existed when this
        // screen loaded but was reset back to the default during this
        // edit (resetToDefault only clears local state - the underlying
        // row needs an explicit delete).
        for (appId, langValues) in overrideValues {
          for (langCode, value) in langValues {
            _ = try await valueUsecase.save(keyId: keyId, lang: langCode, value: value, appId: appId)
          }
        }
        for key in originalOverrideKeys where overrideValues[key.appId]?[key.lang] == nil {
          try await valueUsecase.removeOverride(keyId: keyId, lang: key.lang, appId: key.appId)
        }

        await MainActor.run {
          saveResult = .idle()
          saveEvent = .push(.saved)
        }
      } catch {
        await MainActor.run {
          saveResult = .failure(error: "Failed to save translations. Please try again.")
        }
      }
    }
  }
}
