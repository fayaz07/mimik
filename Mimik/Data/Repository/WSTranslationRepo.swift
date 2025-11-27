//
//  WSTranslationRepo.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//

import CoreData

protocol WSTranslationRepo {
  func addTranslation(
    key: String,
    workspaceId: UUID,
    excludedApps: [UUID]
  ) async throws -> TranslationKeyDTO
}

class WSTranslationRepoImpl: WSTranslationRepo {
  private let localKeySource: WSTranslationKeyLocalDataSource
 
  init(localKeySource: WSTranslationKeyLocalDataSource) {
    self.localKeySource = localKeySource
  }
  
  func addTranslation(key: String, workspaceId: UUID, excludedApps: [UUID]) async throws -> TranslationKeyDTO {
    return try await localKeySource.create(key: key, workspaceId: workspaceId, excludedApps: excludedApps)
  }
}
