//
//  WorkspaceDTO.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 16/10/25.
//

import Foundation

struct WorkspaceDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let name: String
  let desc: String
  let defLang: String
  let createdAt: Date
  let updatedAt: Date
  let lastAccessed: Date
}

extension WorkspaceEntity {
  func toDTO() -> WorkspaceDTO {
    WorkspaceDTO(
      id: id!,
      name: name!,
      desc: desc!,
      defLang: defLang ?? "",
      createdAt: createdAt!,
      updatedAt: updatedAt ?? createdAt!,
      lastAccessed: lastAccessed!
    )
  }
}
