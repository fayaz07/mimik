//
//  WSTranslationKeyLocalDataSource.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//

@preconcurrency import CoreData

class WSTranslationKeyLocalDataSource {
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  private func _fetchOneByIdRequest(id: UUID) -> NSFetchRequest<TranslationKeyEntity> {
    let request: NSFetchRequest<TranslationKeyEntity> = TranslationKeyEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    request.fetchLimit = 1
    
    return request
  }
  
  func fetchById(id: UUID) async throws -> TranslationKeyEntity? {
    let results = try context.fetch(_fetchOneByIdRequest(id: id))
    return results.first
  }
  
  func fetchByWorkspaceId(workspaceId: UUID) async throws -> [TranslationKeyEntity] {
    let request: NSFetchRequest<TranslationKeyEntity> = TranslationKeyEntity.fetchRequest()
    request.predicate = NSPredicate(format: "workspaceId == %@", workspaceId as CVarArg)
    let results = try context.fetch(request)
    return results
  }
  
  func findByKey(key: String, workspaceId: UUID) async throws -> [TranslationKeyEntity] {
    let request: NSFetchRequest<TranslationKeyEntity> = TranslationKeyEntity.fetchRequest()
    request.predicate = NSPredicate(format: "key == %@ and workspaceId == %@", key as CVarArg, workspaceId as CVarArg)
    return try context.fetch(request)
  }

  func findByKey(key: String, workspaceId: UUID, groupId: UUID) async throws -> [TranslationKeyEntity] {
    let request: NSFetchRequest<TranslationKeyEntity> = TranslationKeyEntity.fetchRequest()
    request.predicate = NSPredicate(
      format: "key == %@ and workspaceId == %@ and groupId == %@",
      key as CVarArg,
      workspaceId as CVarArg,
      groupId as CVarArg
    )
    return try context.fetch(request)
  }

  func fetchByGroupId(groupId: UUID) async throws -> [TranslationKeyEntity] {
    let request: NSFetchRequest<TranslationKeyEntity> = TranslationKeyEntity.fetchRequest()
    request.predicate = NSPredicate(format: "groupId == %@", groupId as CVarArg)
    request.sortDescriptors = [
      NSSortDescriptor(key: "createdAt", ascending: true)
    ]
    return try context.fetch(request)
  }

  func create(
    key: String,
    workspaceId: UUID,
    groupId: UUID,
    excludedApps: [UUID]
  ) async throws -> TranslationKeyDTO {
    let doc = TranslationKeyEntity(context: context)
    doc.id = UUID()
    doc.key = key
    doc.workspaceId = workspaceId
    doc.groupId = groupId
    doc.author = "{}"
    doc.createdAt = Date()
    doc.updatedAt = Date()
    doc.excludedAppsArray = excludedApps

    try await context.perform { [weak context] in
      if context?.hasChanges == true {
        do {
          try context?.save()
        } catch {
          throw error
        }
      }
    }
    return doc.toDTO()
  }

  func delete(id: UUID) async throws {
    let request = _fetchOneByIdRequest(id: id)

    try await context.perform {
      [weak context] in

      if let object = try context?.fetch(request).first {
        context?.delete(object)
        try context?.save()
      }
    }
  }

  func updateExcludedApps(id: UUID, excludedApps: [UUID]) async throws -> TranslationKeyDTO {
    guard let doc = try await fetchById(id: id) else {
      throw FetchError.NotFound
    }
    doc.excludedAppsArray = excludedApps
    doc.updatedAt = Date()

    try await context.perform { [weak context] in
      if context?.hasChanges == true {
        try context?.save()
      }
    }
    return doc.toDTO()
  }
}
