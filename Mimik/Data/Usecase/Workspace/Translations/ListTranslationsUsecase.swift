//
//  ListTranslationsUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//
import CoreData

class ListTranslationsUsecase {
  private let repo: WSTranslationRepo
  
  init(repo: WSTranslationRepo) {
    self.repo = repo
  }
  
  /// Returns the workspace's root group plus every other (non-root) group,
  /// creating the default root group on first use if one doesn't exist yet.
  func getGroups(
    workspaceId: UUID
  ) async throws -> (TranslationGroupDTO, [TranslationGroupDTO]) {
    var allGroups = try await repo.fetchAllGroups(workspaceId: workspaceId)

    var rootGroup: TranslationGroupDTO
    let rootGroupIndex = allGroups.firstIndex(
      where: { $0.key == DEFAULT_KEY_ROOT_TRANSLATION_GROUP })

    if rootGroupIndex == nil || rootGroupIndex == -1 {
      // create root group
      rootGroup = try await repo.addDefGroup(workspaceId: workspaceId)
    } else {
      rootGroup = allGroups[rootGroupIndex!]
      allGroups.remove(at: rootGroupIndex!)
    }

    return (rootGroup, allGroups)
  }
}
