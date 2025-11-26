//
//  WorkspaceLangDTO.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

import Foundation

struct WorkspaceLangDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let workspaceId: UUID
  let code: String
  let name: String
  let rtl: Bool
  let author: String
  let active: Bool
  let createdAt: Date
  let updatedAt: Date
}

extension WorkspaceLangEntity {
  func toDTO(lang: LangDTO) -> WorkspaceLangDTO {
    WorkspaceLangDTO(
      id: id!,
      workspaceId: workspaceId!,
      code: code!,
      name: lang.name,
      rtl: lang.rtl,
      author: author ?? "",
      active: active,
      createdAt: createdAt ?? Date(),
      updatedAt: updatedAt ?? Date()
    )
  }
}
