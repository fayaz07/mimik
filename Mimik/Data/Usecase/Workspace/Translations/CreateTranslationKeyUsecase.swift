//
//  CreateTranslationKeyUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import CoreData

class CreateTranslationKeyUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

  func create(
    workspaceId: UUID,
    groupId: UUID,
    key: String,
    excludedApps: [UUID] = []
  ) async throws -> TranslationKeyDTO {
    return try await repo.addTranslation(
      key: key,
      groupId: groupId,
      workspaceId: workspaceId,
      excludedApps: excludedApps
    )
  }
}
