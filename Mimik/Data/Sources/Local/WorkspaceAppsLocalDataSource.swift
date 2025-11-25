//
//  WorkspaceAppsLocalDataSource.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

@preconcurrency import CoreData

final class WorkspaceAppsLocalDataSource {
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
    
  private func _fetchOneByIdRequest(id: UUID) -> NSFetchRequest<AppEntity> {
    let request: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    request.fetchLimit = 1
    
    return request
  }
  
  func fetchById(id: UUID) async throws -> AppEntity? {
    let results = try context.fetch(_fetchOneByIdRequest(id: id))
    return results.first
  }

  func fetchAll() async throws -> [AppEntity] {
    let request: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
    let results = try context.fetch(request)
    return results
  }
  
  func findByName(
    name: String,
    workspaceId: UUID,
    appPlatformId: String
  ) async throws -> [AppEntity] {
    let request: NSFetchRequest<AppEntity> = AppEntity.fetchRequest()
    request.predicate = NSPredicate(
      format: "name == %@ and workspaceId == %@ and appPlatformId == %@",
      name as CVarArg,
      workspaceId as CVarArg,
      appPlatformId as CVarArg
    )
    return try context.fetch(request)
  }
  
  func create(
    name: String, description: String?,
    workspaceId: UUID,
    appPlatformId: String
  ) async throws -> WorkspaceAppDTO {
    let doc = AppEntity(context: context)
    doc.id = UUID()
    doc.name = name
    doc.desc = description ?? ""
    doc.appPlatformId = appPlatformId
    doc.workspaceId = workspaceId
    doc.createdAt = Date()
    doc.updatedAt = Date()
    doc.lastAccessed = Date()
    
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
  
  func saveAccessTime(id: UUID) async throws {
    let doc = try context.fetch(_fetchOneByIdRequest(id: id)).first
    
    if doc != nil {
      let now = Date()
      doc?.lastAccessed = now
      
      _ = try? context.save()
    }
  }
}
