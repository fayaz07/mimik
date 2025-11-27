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
}

extension TranslationValueEntity {
  func toDTO() -> TranslationValueDTO {
    TranslationValueDTO(
      id: id!,
      keyId: keyId!,
      lang: lang!,
      value: value ?? "",
      approved: approved,
      approvedBy: approvedBy!,
      translatedBy: translatedBy!,
      createdAt: createdAt!,
      updatedAt: updatedAt!
    )
  }
}
