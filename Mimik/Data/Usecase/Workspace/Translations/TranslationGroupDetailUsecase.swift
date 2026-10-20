//
//  TranslationGroupDetailUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 04/05/26.
//

import Foundation

class TranslationGroupDetailUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }
  
  func getGroup(
    id: UUID
  ) async throws -> TranslationGroupDTO {
    let res = try await repo.fetchGroup(id: id)
    if res == nil {
      throw FetchError.NotFound
    }
    return res!
  }
  
  func getChildren(id: UUID) async throws -> [TranslationGroupDTO] {
    return try await repo.fetchGroupsByParent(parentId: id)
  }

  func getKeys(groupId: UUID) async throws -> [TranslationKeyDTO] {
    return try await repo.fetchKeysByGroupId(groupId: groupId)
  }
  
  func getRootGroupsByWorkspaceId(workspaceId: UUID) async throws -> [TranslationGroupDTO] {
    return try await repo.fetchRootGroupsByWorkspaceId(workspaceId: workspaceId)
  }

}
