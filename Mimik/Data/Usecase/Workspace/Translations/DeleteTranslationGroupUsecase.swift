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

  /// Deletes a group and all its descendants recursively.
  func delete(groupId: UUID, workspaceId: UUID) async throws {
//    let allGroups = try await repo.fetchAllGroups(workspaceId: workspaceId)
//    let idsToDelete = getAllDescendantIds(groupId: groupId, allGroups: allGroups) + [groupId]
//    for id in idsToDelete {
//      try await repo.deleteGroup(id: id)
//    }
  }

  private func getAllDescendantIds(groupId: UUID, allGroups: [TranslationGroupDTO]) -> [UUID] {
    allGroups
      .filter { $0.parentGroupId == groupId }
      .flatMap { [self] child in [child.id] + getAllDescendantIds(groupId: child.id, allGroups: allGroups) }
  }
}
