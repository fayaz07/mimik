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

  /// The key as it should be shown in UI. The workspace's implicit root
  /// group is stored with the sentinel key "root" - show a friendlier
  /// name for it instead of leaking that implementation detail.
  var displayLabel: String {
    key == DEFAULT_KEY_ROOT_TRANSLATION_GROUP ? "Translations" : key
  }
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
