//
//  DisableLanguageUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//

import CoreData

final class ToggleLangStatusUsecase {
  private let repo: WSLanguagesRepo
  
  init(repo: WSLanguagesRepo) {
    self.repo = repo
  }
  
  func execute(languageId: UUID) async throws -> WorkspaceLangEntity? {
    return try await repo.toggleActiveStatus(id: languageId)
  }
}
