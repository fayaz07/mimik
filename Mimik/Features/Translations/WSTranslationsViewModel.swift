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
  
  init(
    listUseCase: ListTranslationsUsecase,
  ) {
    self.listUseCase = listUseCase
  }
  
  var groups: ViewState<(TranslationGroupDTO, [TranslationGroupDTO])> = .loading()
  var rootGroup: ViewState<TranslationGroupDTO> = .loading()
  
  func fetchRootGroup(workspaceId: UUID) {
    rootGroup = .loading()
    Task {
      do {
//        let result =
      }
    }
  }
  
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
}
