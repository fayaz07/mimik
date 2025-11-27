//
//  WSAppsRepo.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import CoreData

protocol WSAppsRepo {
  func getById(id: UUID) async throws -> AppEntity?
  func getByWorkspaceId(workspaceId: UUID) async throws -> [WSAppDTO]
  func create(name: String, description: String, workspaceId: UUID, appPlatformId: String) async throws -> WSAppDTO
  func delete(id: UUID) async throws
  func findByName(name: String, workspaceId: UUID, appPlatformId: String) async throws -> [AppEntity]
  func saveAccessTime(id: UUID) async throws
}

final class WSAppsRepoImpl: WSAppsRepo {
  private let localSource: WSAppsLocalDataSource
  
  init(localSource: WSAppsLocalDataSource) {
    self.localSource = localSource
  }
  
  func getById(id: UUID) async throws -> AppEntity? {
    return try await localSource.fetchById(id: id)
  }
  
  func getByWorkspaceId(workspaceId: UUID) async throws -> [WSAppDTO] {
    let res = try await localSource.fetchByWorkspaceId(workspaceId: workspaceId)
    return res.map { $0.toDTO() }
  }
  
  func create(
    name: String,
    description: String,
    workspaceId: UUID,
    appPlatformId: String
  ) async throws -> WSAppDTO {
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
