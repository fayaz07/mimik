//
//  WorkspaceAppDTO.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 21/11/25.
//

import Foundation

struct WorkspaceAppDTO: Identifiable, Sendable, Hashable {
  let id: UUID
  let name: String
  let desc: String
  let workspaceId: UUID
  let appPlatformId: String
  let createdAt: Date
  let updatedAt: Date
  let lastAccessed: Date
}

extension AppEntity {
  func toDTO() -> WorkspaceAppDTO {
    WorkspaceAppDTO(
      id: id!,
      name: name!,
      desc: desc!,
      workspaceId: workspaceId!,
      appPlatformId: appPlatformId!,
      createdAt: createdAt!,
      updatedAt: updatedAt!,
      lastAccessed: lastAccessed!
    )
  }
}
