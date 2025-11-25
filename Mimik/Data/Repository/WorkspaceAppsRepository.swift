//
//  WorkspaceAppsRepository.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import CoreData

protocol WorkspaceAppsRepository {
  func getById(id: UUID) async throws -> AppEntity?
  func getAll() async throws -> [WorkspaceAppDTO]
  func create(name: String, description: String, workspaceId: UUID, appPlatformId: String) async throws -> WorkspaceAppDTO
  func delete(id: UUID) async throws
  func findByName(name: String, workspaceId: UUID, appPlatformId: String) async throws -> [AppEntity]
  func saveAccessTime(id: UUID) async throws
}

final class WorkspaceAppsRepositoryImpl: WorkspaceAppsRepository {
  private let localSource: WorkspaceAppsLocalDataSource
  
  init(localSource: WorkspaceAppsLocalDataSource) {
    self.localSource = localSource
  }
  
  func getById(id: UUID) async throws -> AppEntity? {
    return try await localSource.fetchById(id: id)
  }
  
  func getAll() async throws -> [WorkspaceAppDTO] {
    let res = try await localSource.fetchAll()
    return res.map { $0.toDTO() }
  }
  
  func create(
    name: String,
    description: String,
    workspaceId: UUID,
    appPlatformId: String
  ) async throws -> WorkspaceAppDTO {
    return try await localSource.create(
      name: name,
      description: description,
      workspaceId: workspaceId,
      appPlatformId: appPlatformId
    )
  }
  
  func delete(id: UUID) async throws {
    try await localSource.delete(id: id)
  }
  
  func findByName(name: String, workspaceId: UUID, appPlatformId: String) async throws -> [AppEntity] {
    try await localSource.findByName(name: name, workspaceId: workspaceId, appPlatformId: appPlatformId)
  }
  
  func saveAccessTime(id: UUID) async throws {
    try await localSource.saveAccessTime(id: id)
  }
}
