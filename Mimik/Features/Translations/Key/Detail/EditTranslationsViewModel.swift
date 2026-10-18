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

  init(
    getWorkspaceUsecase: GetWorkspaceUsecase,
    langUsecase: AddLanguageUsecase,
    valueUsecase: TranslationValueUsecase,
  ) {
    self.getWorkspaceUsecase = getWorkspaceUsecase
    self.langUsecase = langUsecase
    self.valueUsecase = valueUsecase
  }

  var languages: ViewState<[WSLangDTO]> = .loading()
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
    Task {
      do {
        async let workspaceTask = getWorkspaceUsecase.get(id: workspaceId)
        async let addedLangsTask = langUsecase.getAddedLanguages(workspaceId: workspaceId)
        async let existingValuesTask = valueUsecase.getValues(forKeyId: keyId)

        let (workspace, addedLangs, existingValues) = try await (
          workspaceTask, addedLangsTask, existingValuesTask
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
        }
      } catch {
        await MainActor.run {
          self.languages = .failure(error: "Failed to load languages for this workspace")
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
