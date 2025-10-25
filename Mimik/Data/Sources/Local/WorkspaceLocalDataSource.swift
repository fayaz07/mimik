//
//  WorkspaceLocalSource.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 05/06/25.
//

@preconcurrency import CoreData

final class WorkspaceLocalDataSource {
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  private func _fetchOneByIdRequest(id: UUID) -> NSFetchRequest<WorkspaceEntity> {
    let request: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    request.fetchLimit = 1
    
    return request
  }
  
  func fetchById(id: UUID) async throws -> WorkspaceEntity? {
    let results = try context.fetch(_fetchOneByIdRequest(id: id))
    return results.first
  }
  
  func fetchAll() async throws -> [WorkspaceEntity] {
    let request: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
    let results = try context.fetch(request)
    return results
  }
  
  func findByName(name: String) async throws -> [WorkspaceEntity] {
    let request: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
    request.predicate = NSPredicate(format: "name == %@", name as CVarArg)
    return try context.fetch(request)
  }
  
  func save(name: String, description: String?) async throws -> WorkspaceDTO {
    let doc = WorkspaceEntity(context: context)
    doc.id = UUID()
    doc.name = name
    doc.desc = description ?? ""
    doc.createdAt = Date()
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
    let request = _fetchOneByIdRequest(id: id)
    let doc = try context.fetch(_fetchOneByIdRequest(id: id)).first
    
    if doc != nil {
      let now = Date()
      doc?.lastAccessed = now
      
      _ = try? context.save()
    }
  }
}
