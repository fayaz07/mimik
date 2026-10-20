//
//  ListWorkspaceAppsUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import Foundation

class ListWorkspaceAppsUsecase {
  private let repo: WSAppsRepo

  init(repo: WSAppsRepo) {
    self.repo = repo
  }

  func list(workspaceId: UUID) async throws -> [WSAppDTO] {
    return try await repo.getByWorkspaceId(workspaceId: workspaceId)
  }
}
