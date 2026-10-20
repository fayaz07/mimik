//
//  RenameTranslationGroupUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import Foundation

class RenameTranslationGroupUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

  func rename(
    workspaceId: UUID,
    groupId: UUID,
    parentGroupId: UUID?,
    name: String
  ) async throws -> TranslationGroupDTO {
    return try await repo.renameGroup(
      id: groupId,
      workspaceId: workspaceId,
      parentGroupId: parentGroupId,
      name: name
    )
  }
}
