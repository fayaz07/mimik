//
//  WorkspaceRepository.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 05/06/25.
//
import CoreData

protocol WorkspaceRepository {
  func getById(id: UUID) async throws -> WorkspaceEntity?
  func getAll() async throws -> [WorkspaceDTO]
  func create(name: String, description: String) async throws
  func delete(id: UUID) async throws
  func findByName(name: String) async throws -> [WorkspaceEntity]
}

final class WorkspaceRepositoryImpl: WorkspaceRepository {
  private let localSource: WorkspaceLocalDataSource
  
  init(localSource: WorkspaceLocalDataSource) {
    self.localSource = localSource
  }
  
  func getById(id: UUID) async throws -> WorkspaceEntity? {
    return try await localSource.fetchById(id: id)
  }
  
  func getAll() async throws -> [WorkspaceDTO] {
    let res = try await localSource.fetchAll()
    return res.map { $0.toDTO() }
  }
  
  func create(name: String, description: String) async throws {
    try await localSource.save(name: name, description: description)
  }
  
  func delete(id: UUID) async throws {
    try await localSource.delete(id: id)
  }
  
  func findByName(name: String) async throws -> [WorkspaceEntity] {
    try await localSource.findByName(name: name)
  }
}
