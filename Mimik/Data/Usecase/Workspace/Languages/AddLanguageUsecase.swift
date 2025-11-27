//
//  AddLanguageUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

import CoreData

final class AddLanguageUsecase {
  private let repo: WSLanguagesRepo
  private let langRepo: LangRepository
  
  init(repo: WSLanguagesRepo, langRepo: LangRepository) {
    self.repo = repo
    self.langRepo = langRepo
  }
 
  func getAddedLanguages(workspaceId: UUID) async throws -> [String: WSLangDTO] {
    let selected = try await repo.getByWorkspaceId(workspaceId: workspaceId)
    
    return Dictionary(uniqueKeysWithValues: selected.map {
      ($0.code!, $0.toDTO(lang: langRepo.get(code: $0.code!)))
    })
  }
  
  func getAllLanguages() -> [String: LangDTO] {
    return langRepo.getAll()
  }
  
  func add(lang: String, workspaceId: UUID) async throws -> WSLangDTO {
    return try await repo.add(workspaceId: workspaceId, lang: lang).toDTO(lang: langRepo.get(code: lang))
  }
}
