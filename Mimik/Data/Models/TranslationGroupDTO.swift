//
//  TranslationGroupDTO.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 28/11/25.
//

import Foundation

struct TranslationGroupDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let workspaceId: UUID
  let key: String
  let parentGroupId: UUID?
  let createdAt: Date
  let updatedAt: Date
}

extension TranslationGroupEntity {
  func toDTO() -> TranslationGroupDTO {
    TranslationGroupDTO(
      id: id!,
      workspaceId: workspaceId!,
      key: key!,
      parentGroupId: parentGroupId,
      createdAt: createdAt!,
      updatedAt: updatedAt!
    )
  }
}
