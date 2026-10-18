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

  func save(
    keyId: UUID,
    lang: String,
    value: String
  ) async throws -> TranslationValueDTO {
    return try await repo.upsertValue(
      keyId: keyId,
      lang: lang,
      value: value,
      translatedBy: "{}"
    )
  }
}
