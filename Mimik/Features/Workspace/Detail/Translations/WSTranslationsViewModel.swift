//
//  WSTranslationsViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//
import Foundation
import CoreData

@Observable
class WSTranslationsViewModel {
  
  private let listUseCase: ListTranslationsUsecase
  private let createUseCase: CreateTranslationUsecase
  
  init(
    listUseCase: ListTranslationsUsecase,
    createUseCase: CreateTranslationUsecase
  ) {
    self.listUseCase = listUseCase
    self.createUseCase = createUseCase
  }
  
  var groups: ViewState<(TranslationGroupDTO, [TranslationGroupDTO])> = .loading()
 
  func fetchGroups(workspaceId: UUID) {
    groups = .loading()
    Task {
      do {
        let result = try await listUseCase.getGroups(workspaceId: workspaceId)
        await MainActor.run {
          groups = .success(data: result)
        }
      } catch {
        await MainActor.run {
          groups = .failure(error: "Failed to fetch translations")
        }
      }
    }
  }
  
  func addGroup(workspaceId: UUID, name: String, parentId: UUID? = nil) {
    Task {
      try await createUseCase.create(
        workspaceId: workspaceId,
        key: name,
        parentGroupId: parentId
      )
      fetchGroups(workspaceId: workspaceId)
    }
  }
}
