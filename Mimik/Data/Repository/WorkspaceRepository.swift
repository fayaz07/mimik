//
//  WorkspaceRepository.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 05/06/25.
//
import CoreData

protocol WorkspaceRepository {
  func getAll() async throws -> [WorkspaceEntity]
  func create(name: String, description: String) async throws
  func delete(id: UUID) async throws
}

final class WorkspaceRepositoryImpl: WorkspaceRepository {
  private let localSource: WorkspaceLocalDataSource
  
  init(localSource: WorkspaceLocalDataSource) {
    self.localSource = localSource
  }
  
  func getAll() async throws -> [WorkspaceEntity] {
    return try await localSource.fetchAll()
  }
  
  func create(name: String, description: String) async throws {
    try await localSource.save(name: name, description: description)
  }
  
  func delete(id: UUID) async throws {
    try await localSource.delete(id: id)
  }
}
