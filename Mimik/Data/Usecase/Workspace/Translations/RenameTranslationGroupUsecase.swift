//
//  RenameTranslationGroupUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 04/05/26.
//

import Foundation

class RenameTranslationGroupUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }

//  func rename(id: UUID, newName: String) async throws -> TranslationGroupDTO {
//    let trimmed = newName.trimmingCharacters(in: .whitespaces)
//    if trimmed.isEmpty { throw ValidationError.EmptyKey }
//    return try await repo.renameGroup(id: id, newName: trimmed)
//  }
}
