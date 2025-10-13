//
//  WorkspaceLocalSource.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 05/06/25.
//

import CoreData

final class WorkspaceLocalDataSource {
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
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
  
  func save(name: String, description: String?) async throws {
    let doc = WorkspaceEntity(context: context)
    doc.id = UUID()
    doc.name = name
    doc.desc = description ?? ""
    
    try await context.perform { [weak context] in
      if context?.hasChanges == true {
        do {
          try context?.save()
        } catch {
          throw error
        }
      }
    }
  }

  func delete(id: UUID) async throws {
    let request: NSFetchRequest<WorkspaceEntity> = WorkspaceEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    
    try await context.perform {
      [weak context] in
      
      if let object = try context?.fetch(request).first {
        context?.delete(object)
        try context?.save()
      }
    }
  }
}
