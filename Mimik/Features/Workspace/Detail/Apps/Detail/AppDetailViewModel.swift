//
//  AppDetailViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import Foundation

/// Loads the data the App Detail screen needs to offer an export - the
/// workspace's active languages and its default language. The export action
/// itself is called directly from the screen (same direct-usecase-call
/// pattern as GroupBreadcrumb's rename/delete), since it's a one-off action
/// rather than state this screen needs to keep around.
@Observable
class AppDetailViewModel {
  private let langUsecase: AddLanguageUsecase
  private let getWorkspaceUsecase: GetWorkspaceUsecase

  init(langUsecase: AddLanguageUsecase, getWorkspaceUsecase: GetWorkspaceUsecase) {
    self.langUsecase = langUsecase
    self.getWorkspaceUsecase = getWorkspaceUsecase
  }

  var languages: ViewState<[WSLangDTO]> = .loading()
  var defaultLang: String = ""

  func load(workspaceId: UUID) {
    languages = .loading()
    Task {
      do {
        async let workspaceTask = getWorkspaceUsecase.get(id: workspaceId)
        async let addedLangsTask = langUsecase.getAddedLanguages(workspaceId: workspaceId)
        let (workspace, addedLangs) = try await (workspaceTask, addedLangsTask)

        let active = addedLangs.values
          .filter { $0.active }
          .sorted { lhs, rhs in
            if lhs.code == workspace.defLang { return true }
            if rhs.code == workspace.defLang { return false }
            return lhs.name < rhs.name
          }

        await MainActor.run {
          self.defaultLang = workspace.defLang
          self.languages = .success(data: active)
        }
      } catch {
        await MainActor.run {
          self.languages = .failure(error: "Failed to load this workspace's languages")
        }
      }
    }
  }
}
