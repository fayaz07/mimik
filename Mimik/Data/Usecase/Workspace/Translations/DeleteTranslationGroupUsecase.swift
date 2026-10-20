//
//  DeleteTranslationGroupUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 04/05/26.
//

import Foundation

class DeleteTranslationGroupUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

  /// Deletes a group and all its descendants recursively - along with every
  /// key (and each key's values) that lives directly inside any of them.
  func delete(groupId: UUID, workspaceId: UUID) async throws {
    let allGroups = try await repo.fetchAllGroups(workspaceId: workspaceId)
    let idsToDelete = [groupId] + getAllDescendantIds(groupId: groupId, allGroups: allGroups)

    for id in idsToDelete {
      let keys = try await repo.fetchKeysByGroupId(groupId: id)
      let values = try await repo.fetchValues(forKeyIds: keys.map { $0.id })
      for value in values {
        try await repo.deleteValue(id: value.id)
      }
      for key in keys {
        try await repo.deleteKey(id: key.id)
      }
      try await repo.deleteGroup(id: id)
    }
  }

  private func getAllDescendantIds(groupId: UUID, allGroups: [TranslationGroupDTO]) -> [UUID] {
    allGroups
      .filter { $0.parentGroupId == groupId }
      .flatMap { [self] child in [child.id] + getAllDescendantIds(groupId: child.id, allGroups: allGroups) }
  }
}
