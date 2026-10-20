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

  var saveResult: ViewState<String> = .idle()

  @Published @ObservationIgnored var saveEvent: ViewEvent<AddTranslationEvents> = .none()

  func value(for code: String) -> String {
    values[code] ?? ""
  }

  func setValue(_ value: String, for code: String) {
    values[code] = value
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
        for value in existingValues {
          initialValues[value.lang] = value.value
        }

        await MainActor.run {
          self.defaultLang = workspace.defLang
          self.values = initialValues
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
