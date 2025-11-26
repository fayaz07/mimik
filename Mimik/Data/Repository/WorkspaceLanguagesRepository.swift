//
//  WorkspaceLanguagesRepository.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

import CoreData

protocol WorkspaceLanguagesRepository {
  func getByWorkspaceId(workspaceId: UUID) async throws -> [WorkspaceLangEntity]
  func add(workspaceId: UUID, lang: String) async throws -> WorkspaceLangEntity
  func disable(id: UUID) async throws
}

final class WorkspaceLanguagesRepositoryImpl: WorkspaceLanguagesRepository {
  private let localSource: WorkspaceLanguagesLocalDataSource
  
  init(localSource: WorkspaceLanguagesLocalDataSource) {
    self.localSource = localSource
  }
  
  func getByWorkspaceId(workspaceId: UUID) async throws -> [WorkspaceLangEntity] {
    let result = try await localSource.fetchByWorkspaceId(
      workspaceId: workspaceId
    )
    return result
  }
  
  func add(workspaceId: UUID, lang: String) async throws -> WorkspaceLangEntity {
    let existingRecord = try await localSource.findByCode(code: lang, workspaceId: workspaceId)
    if !existingRecord.isEmpty {
      return existingRecord.first!
    }
    return try await localSource.create(
      workspaceId: workspaceId,
      code: lang,
    )
  }
  
  func disable(id: UUID) async throws {
    try await localSource.disable(id: id)
  }
}
