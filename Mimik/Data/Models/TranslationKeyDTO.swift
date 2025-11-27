//
//  TranslationsDTO.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//
import Foundation

struct TranslationKeyDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let key: String
  let author: String
  let workspaceId: UUID
  let createdAt: Date
  let updatedAt: Date
}

extension TranslationKeyEntity {
  var excludedAppsArray: [UUID] {
          get { excludedApps as? [UUID] ?? [] }
          set { excludedApps = newValue as NSObject? }
      }
  
  func toDTO() -> TranslationKeyDTO {
    TranslationKeyDTO(
      id: id!,
      key: key!,
      author: author!,
      workspaceId: workspaceId!,
      createdAt: createdAt!,
      updatedAt: updatedAt!
    )
  }
}
