//
//  WSTranslationGroupLocalDataSource.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 28/11/25.
//

@preconcurrency import CoreData

class WSTranslationGroupLocalDataSource {
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  private func _fetchOneByIdRequest(id: UUID) -> NSFetchRequest<TranslationGroupEntity> {
    let request: NSFetchRequest<TranslationGroupEntity> = TranslationGroupEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    request.fetchLimit = 1
    
    return request
  }
  
  func printAll() async throws {
    let request: NSFetchRequest<TranslationGroupEntity> = TranslationGroupEntity.fetchRequest()
    request.sortDescriptors = [
      NSSortDescriptor(key: "createdAt", ascending: true)
    ]
    let results = try context.fetch(request)
    for result in results {
      print("ID: \(result.id), parent: \(result.parentGroupId?.uuidString ?? "nil"), key: \(result.key) \n")
    }
  }
  
  func fetchRootGroupsByWorkspaceId(workspaceId: UUID) async throws -> [TranslationGroupEntity] {
    let request: NSFetchRequest<TranslationGroupEntity> = TranslationGroupEntity.fetchRequest()
    request.predicate = NSPredicate(format: "workspaceId == %@ and parentGroupId == nil", workspaceId as CVarArg)
    request.sortDescriptors = [
      NSSortDescriptor(key: "createdAt", ascending: true)
    ]
    let results = try context.fetch(request)
    return results
  }
  
  func fetchByParentId(id: UUID) async throws -> [TranslationGroupEntity] {
    try await printAll()
    let request: NSFetchRequest<TranslationGroupEntity> = TranslationGroupEntity.fetchRequest()
    request.predicate = NSPredicate(format: "parentGroupId == %@", id as CVarArg)
    request.sortDescriptors = [
      NSSortDescriptor(key: "createdAt", ascending: true)
    ]
    let results = try context.fetch(request)
    return results
  }
  
  func fetchById(id: UUID) async throws -> TranslationGroupEntity? {
    let results = try context.fetch(_fetchOneByIdRequest(id: id))
    return results.first
  }
  
  func fetchByWorkspaceId(workspaceId: UUID) async throws -> [TranslationGroupEntity] {
    let request: NSFetchRequest<TranslationGroupEntity> = TranslationGroupEntity.fetchRequest()
    request.predicate = NSPredicate(format: "workspaceId == %@", workspaceId as CVarArg)
    request.sortDescriptors = [
        NSSortDescriptor(key: "createdAt", ascending: true)
    ]
    let results = try context.fetch(request)
    return results
  }
  
  func findByKey(
    key: String,
    workspaceId: UUID,
    parentGroupId: UUID? = nil
  ) async throws -> [TranslationGroupEntity] {
    let request: NSFetchRequest<TranslationGroupEntity> = TranslationGroupEntity.fetchRequest()
    if let parentGroupId {
      request.predicate = NSPredicate(format: "key == %@ and workspaceId == %@ and parentGroupId == %@", key as CVarArg, workspaceId as CVarArg, parentGroupId as CVarArg)
    } else {
      request.predicate = NSPredicate(format: "key == %@ and workspaceId == %@", key as CVarArg, workspaceId as CVarArg)
    }
    return try context.fetch(request)
  }
  
  func create(
    key: String,
    workspaceId: UUID,
    parentGroupId: UUID? = nil
  ) async throws -> TranslationGroupDTO {
    print("key: \(key), workspaceId: \(workspaceId), parentGroupId: \(String(describing: parentGroupId))")
    let doc = TranslationGroupEntity(context: context)
    doc.id = UUID()
    doc.key = key
    doc.workspaceId = workspaceId
    doc.parentGroupId = parentGroupId
    doc.createdAt = Date()
    doc.updatedAt = Date()
        
    try await context.perform { [weak context] in
      if context?.hasChanges == true {
        do {
          print("saving")
          try context?.save()
          print("saved")
        } catch {
          print(error)
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
}
