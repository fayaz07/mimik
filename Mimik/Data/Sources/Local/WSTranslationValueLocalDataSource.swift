//
//  WSTranslationValueLocalDataSource.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//

@preconcurrency import CoreData

class WSTranslationValueLocalDataSource {
  private let context: NSManagedObjectContext
  
  init(context: NSManagedObjectContext) {
    self.context = context
  }
  
  private func _fetchOneByIdRequest(id: UUID) -> NSFetchRequest<TranslationValueEntity> {
    let request: NSFetchRequest<TranslationValueEntity> = TranslationValueEntity.fetchRequest()
    request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
    request.fetchLimit = 1
    
    return request
  }
  
  func fetchById(id: UUID) async throws -> TranslationValueEntity? {
    let results = try context.fetch(_fetchOneByIdRequest(id: id))
    return results.first
  }
  
  func fetchByKeyIds(_ keyIds: [UUID]) async throws -> [TranslationValueEntity] {
    guard !keyIds.isEmpty else { return [] }
    let request: NSFetchRequest<TranslationValueEntity> = TranslationValueEntity.fetchRequest()
    request.predicate = NSPredicate(format: "keyId IN %@", keyIds as CVarArg)
    return try context.fetch(request)
  }

  func findByKeyAndLang(keyId: UUID, lang: String) async throws -> [TranslationValueEntity] {
    let request: NSFetchRequest<TranslationValueEntity> = TranslationValueEntity.fetchRequest()
    request.predicate = NSPredicate(
      format: "keyId == %@ and lang == %@",
      keyId as CVarArg,
      lang as CVarArg
    )
    request.fetchLimit = 1
    return try context.fetch(request)
  }

  /// Creates the value row for (keyId, lang) if it doesn't exist yet,
  /// otherwise updates the existing one. Translations are always edited
  /// in place rather than appended, since there's exactly one value per
  /// key per language.
  func upsert(
    keyId: UUID,
    lang: String,
    value: String,
    translatedBy: String
  ) async throws -> TranslationValueDTO {
    let existing = try await findByKeyAndLang(keyId: keyId, lang: lang)

    var result: TranslationValueDTO!

    try await context.perform { [weak context] in
      let doc = existing.first ?? TranslationValueEntity(context: context!)
      if existing.isEmpty {
        doc.id = UUID()
        doc.keyId = keyId
        doc.lang = lang
        doc.createdAt = Date()
        doc.approved = false
        doc.approvedBy = ""
      }
      doc.value = value
      doc.translatedBy = translatedBy
      doc.updatedAt = Date()

      if context?.hasChanges == true {
        do {
          try context?.save()
        } catch {
          throw error
        }
      }
      result = doc.toDTO()
    }

    return result
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
