//
//  WSTranslationRepo.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//

import CoreData

let DEFAULT_KEY_ROOT_TRANSLATION_GROUP: String = "root"

protocol WSTranslationRepo {
  func addTranslation(
    key: String,
    workspaceId: UUID,
    excludedApps: [UUID]
  ) async throws -> TranslationKeyDTO
  func addDefGroup(workspaceId: UUID) async throws -> TranslationGroupDTO
  func addGroup(workspaceId: UUID, name: String, parentId: UUID?) async throws -> TranslationGroupDTO
  func fetchAllGroups(workspaceId: UUID) async throws -> [TranslationGroupDTO]
  func fetchGroup(id: UUID) async throws -> TranslationGroupDTO?
  func fetchGroupsByParent(parentId: UUID) async throws -> [TranslationGroupDTO]
  func fetchRootGroupsByWorkspaceId(workspaceId: UUID) async throws -> [TranslationGroupDTO]
}

enum ValidationError: Error {
  case EmptyKey
  case AlreadyExists
}

class WSTranslationRepoImpl: WSTranslationRepo {
  private let localGroupSource: WSTranslationGroupLocalDataSource
  private let localKeySource: WSTranslationKeyLocalDataSource
  private let localValueSource: WSTranslationValueLocalDataSource
 
  init(
    localKeySource: WSTranslationKeyLocalDataSource,
    localGroupSource: WSTranslationGroupLocalDataSource,
    localValueSource: WSTranslationValueLocalDataSource
  ) {
    self.localKeySource = localKeySource
    self.localGroupSource = localGroupSource
    self.localValueSource = localValueSource
  }
  
  func addDefGroup(workspaceId: UUID) async throws -> TranslationGroupDTO {
    let existingDoc = try await localGroupSource.findByKey(key: DEFAULT_KEY_ROOT_TRANSLATION_GROUP, workspaceId: workspaceId)
    if !existingDoc.isEmpty {
      return existingDoc.first!.toDTO()
    }
    
    return try await localGroupSource.create(key: DEFAULT_KEY_ROOT_TRANSLATION_GROUP, workspaceId: workspaceId)
  }
  
  func addGroup(
    workspaceId: UUID,
    name: String,
    parentId: UUID?
  ) async throws -> TranslationGroupDTO {
    if name.isEmpty {
      throw ValidationError.EmptyKey
    }
    let existingDoc = try await localGroupSource.findByKey(
      key: name, workspaceId: workspaceId, parentGroupId: parentId
    )
    if !existingDoc.isEmpty {
      throw ValidationError.AlreadyExists
    }
    return try await localGroupSource.create(key: name, workspaceId: workspaceId, parentGroupId: parentId)
  }
  
  func fetchAllGroups(workspaceId: UUID) async throws -> [TranslationGroupDTO] {
    return try await localGroupSource.fetchByWorkspaceId(workspaceId: workspaceId)
      .map { $0.toDTO() }
  }
  
  func addTranslation(key: String, workspaceId: UUID, excludedApps: [UUID]) async throws -> TranslationKeyDTO {
    return try await localKeySource.create(key: key, workspaceId: workspaceId, excludedApps: excludedApps)
  }
  
  func fetchGroup(id: UUID) async throws -> TranslationGroupDTO? {
    return try await localGroupSource.fetchById(id: id)?.toDTO() ?? nil
  }
  
  func fetchGroupsByParent(parentId: UUID) async throws -> [TranslationGroupDTO] {
    return try await localGroupSource.fetchByParentId(id: parentId).map { $0.toDTO() }
  }
  
  func fetchRootGroupsByWorkspaceId(workspaceId: UUID) async throws -> [TranslationGroupDTO] {
    return try await localGroupSource.fetchRootGroupsByWorkspaceId(workspaceId: workspaceId).map { $0.toDTO() }
  }
}
