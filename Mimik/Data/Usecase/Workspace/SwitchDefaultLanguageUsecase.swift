//
//  SwitchDefaultLanguageUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//

import CoreData

final class SwitchDefaultLanguageUsecase {
  private let repo: WorkspaceRepository
  
  init(repo: WorkspaceRepository) {
    self.repo = repo
  }
  
  func execute(id: UUID, lang: String) async throws -> WorkspaceDTO? {
    return try await repo.switchDefaultLang(id: id, lang: lang)
  }
}
