//
//  TranslationsDTO.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//
import Foundation

struct TranslationsDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let key: String
  let author: String
  let workspaceId: UUID
  let createdAt: Date
  let updatedAt: Date
}

extension TranslationKeyEntity {
  func toDTO() -> TranslationsDTO {
    TranslationsDTO(
      id: id!,
      key: key!,
      author: author!,
      workspaceId: workspaceId!,
      createdAt: createdAt!,
      updatedAt: updatedAt!
    )
  }
}
