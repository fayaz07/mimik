//
//  TranslationValueUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import Foundation

class TranslationValueUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

  func getValues(forKeyIds keyIds: [UUID]) async throws -> [TranslationValueDTO] {
    return try await repo.fetchValues(forKeyIds: keyIds)
  }

  func getValues(forKeyId keyId: UUID) async throws -> [TranslationValueDTO] {
    return try await repo.fetchValues(forKeyIds: [keyId])
  }

  /// `appId: nil` saves the shared default every app falls back to;
  /// passing a specific app's id saves (or updates) that app's own
  /// override of this key+lang instead.
  func save(
    keyId: UUID,
    lang: String,
    value: String,
    appId: UUID? = nil
  ) async throws -> TranslationValueDTO {
    return try await repo.upsertValue(
      keyId: keyId,
      lang: lang,
      value: value,
      translatedBy: "{}",
      appId: appId
    )
  }

  /// Reverts a single app back to the shared default for this key+lang by
  /// deleting its override, if one exists.
  func removeOverride(keyId: UUID, lang: String, appId: UUID) async throws {
    try await repo.deleteValueOverride(keyId: keyId, lang: lang, appId: appId)
  }
}
