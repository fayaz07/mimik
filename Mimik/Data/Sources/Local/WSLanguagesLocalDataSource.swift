//
//  WorkspaceLanguagesLocalDataSource.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

@preconcurrency import CoreData

final class WSLanguagesLocalDataSource {
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
    
  private func _fetchOneByIdRequest(id: UUID) -> NSFetchRequest<WorkspaceLangEntity> {
    let request: NSFetchRequest<WorkspaceLangEntity> = WorkspaceLangEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    request.fetchLimit = 1
    
    return request
  }
  
  func fetchById(id: UUID) async throws -> WorkspaceLangEntity? {
    let results = try context.fetch(_fetchOneByIdRequest(id: id))
    return results.first
  }

  func fetchAll() async throws -> [WorkspaceLangEntity] {
    let request: NSFetchRequest<WorkspaceLangEntity> = WorkspaceLangEntity.fetchRequest()
    let results = try context.fetch(request)
    return results
  }
  
  func fetchByWorkspaceId(workspaceId: UUID) async throws -> [WorkspaceLangEntity] {
    let request: NSFetchRequest<WorkspaceLangEntity> = WorkspaceLangEntity.fetchRequest()
    request.predicate = NSPredicate(
      format: "workspaceId == %@",
      workspaceId as CVarArg,
    )
    let results = try context.fetch(request)
    return results
  }
  
  func findByCode(
    code: String,
    workspaceId: UUID
  ) async throws -> [WorkspaceLangEntity] {
    let request: NSFetchRequest<WorkspaceLangEntity> = WorkspaceLangEntity.fetchRequest()
    request.predicate = NSPredicate(
      format: "code == %@ and workspaceId == %@",
      code as CVarArg,
      workspaceId as CVarArg
    )
    return try context.fetch(request)
  }
  
  func create(
    workspaceId: UUID,
    code: String
  ) async throws -> WorkspaceLangEntity {
    let doc = WorkspaceLangEntity(context: context)
    doc.id = UUID()
    doc.workspaceId = workspaceId
    doc.createdAt = Date()
    doc.updatedAt = Date()
    doc.active = true
    doc.code = code
    doc.author = "{}"
    
    try await context.perform { [weak context] in
      if context?.hasChanges == true {
        do {
          try context?.save()
        } catch {
          throw error
        }
      }
    }
    return doc
  }

  func disable(id: UUID) async throws {
    let request = _fetchOneByIdRequest(id: id)
    
    try await context.perform {
      [weak context] in
      
      if let object = try context?.fetch(request).first {
        object.active = false
        try context?.save()
      }
    }
  }
}
