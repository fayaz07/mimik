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
  func create(name: String, description: String) async throws -> WorkspaceDTO
  func delete(id: UUID) async throws
  func findByName(name: String) async throws -> [WorkspaceEntity]
  func saveAccessTime(id: UUID) async throws
  func switchDefaultLang(id: UUID, lang: String) async throws -> WorkspaceDTO?
}

final class WorkspaceRepositoryImpl: WorkspaceRepository {
  private let localSource: WorkspaceLocalDataSource
  private let langRepo: LangRepository
  
  init(localSource: WorkspaceLocalDataSource, langRepo: LangRepository) {
    self.localSource = localSource
    self.langRepo = langRepo
  }
  
  func getById(id: UUID) async throws -> WorkspaceEntity? {
    return try await localSource.fetchById(id: id)
  }
  
  func getAll() async throws -> [WorkspaceDTO] {
    let res = try await localSource.fetchAll()
    return res.map { $0.toDTO() }
  }
  
  func create(name: String, description: String) async throws -> WorkspaceDTO {
    return try await localSource.create(name: name, description: description)
  }
  
  func delete(id: UUID) async throws {
    try await localSource.delete(id: id)
  }
  
  func findByName(name: String) async throws -> [WorkspaceEntity] {
    try await localSource.findByName(name: name)
  }
  
  func saveAccessTime(id: UUID) async throws {
    try await localSource.saveAccessTime(id: id)
  }
  
  func switchDefaultLang(id: UUID, lang: String) async throws -> WorkspaceDTO? {
    // check if lang is valid
    if !langRepo.isValid(code: lang) {
      return nil
    }
    
    let doc = try await localSource.fetchById(id: id)
    if doc == nil {
      return nil
    }
    
    doc?.defLang = lang
    doc?.updatedAt = Date()
    return doc!.toDTO()
  }
}
