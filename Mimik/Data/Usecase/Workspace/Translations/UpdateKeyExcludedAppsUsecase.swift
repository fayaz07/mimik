//
//  UpdateKeyExcludedAppsUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import Foundation

class UpdateKeyExcludedAppsUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

  func update(keyId: UUID, excludedApps: [UUID]) async throws -> TranslationKeyDTO {
    return try await repo.updateExcludedApps(keyId: keyId, excludedApps: excludedApps)
  }
}
