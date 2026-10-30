//
//  TranslationValueDTO.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//
import Foundation

struct TranslationValueDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let keyId: UUID
  let lang: String
  let value: String
  let approved: Bool
  let approvedBy: String
  let translatedBy: String
  let createdAt: Date
  let updatedAt: Date
  /// nil for the shared value every app falls back to; set to a specific
  /// app's id for a value that only overrides that one app (e.g. a
  /// formatted-string placeholder syntax that differs by platform).
  let appId: UUID?
}

extension TranslationValueEntity {
  func toDTO() -> TranslationValueDTO {
    TranslationValueDTO(
      id: id ?? UUID(),
      keyId: keyId ?? UUID(),
      lang: lang ?? "",
      value: value ?? "",
      approved: approved,
      approvedBy: approvedBy ?? "",
      translatedBy: translatedBy ?? "",
      createdAt: createdAt ?? Date(),
      updatedAt: updatedAt ?? Date(),
      appId: appId
    )
  }
}
