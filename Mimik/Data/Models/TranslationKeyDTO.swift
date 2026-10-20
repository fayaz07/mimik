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
  let groupId: UUID?
  let createdAt: Date
  let updatedAt: Date
  /// Apps this key is hidden from. Empty (the default) means it's included
  /// in every app in the workspace - most keys are shared, so exclusion is
  /// opt-in rather than having to opt in to every app individually.
  ///
  /// `var`, not `let` - a `let` with an inline default is left out of the
  /// synthesized memberwise initializer entirely (unlike `var`, which keeps
  /// it as an overridable parameter), which is why toDTO() passing
  /// excludedApps: explicitly was failing to compile.
  var excludedApps: [UUID] = []
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
      author: author ?? "",
      workspaceId: workspaceId!,
      groupId: groupId,
      createdAt: createdAt!,
      updatedAt: updatedAt!,
      excludedApps: excludedAppsArray
    )
  }
}
