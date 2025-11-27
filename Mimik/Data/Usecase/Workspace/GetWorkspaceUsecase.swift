//
//  GetWorkspaceUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//

import CoreData

class GetWorkspaceUsecase {
  private let repo: WorkspaceRepository
  
  init(repo: WorkspaceRepository) {
    self.repo = repo
  }
  
  func get(id: UUID) async throws -> WorkspaceDTO {
    let doc = try await repo.getById(id: id)
    if doc == nil {
      throw NSError(domain: "Workspace not found", code: 0, userInfo: nil)
    }
    return doc!.toDTO()
  }
  
  func getAll() async throws -> [WorkspaceDTO] {
    return try await repo.getAll()
  }
}
