//
//  CreateTranslationUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 01/12/25.
//

import CoreData

class CreateTranslationUsecase {
  private let repo: WSTranslationRepo
  
  init(repo: WSTranslationRepo) {
    self.repo = repo
  }
  
  func create(
    workspaceId: UUID,
    key: String,
    parentGroupId: UUID? = nil
  ) async throws -> TranslationGroupDTO {
    return try await repo.addGroup(
      workspaceId: workspaceId,
      name: key,
      parentId: parentGroupId
    )
  }
}
