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
  
  var currentGroupName: String = ""
  var addGroupResult: ViewState<String> = .idle()
  
  @Published @ObservationIgnored var addGroupEvent: ViewEvent<WSTranslationEvents> = .none()
  
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
    addGroupResult = .loading()
    Task {
      do {
        try await createUseCase.create(
          workspaceId: workspaceId,
          key: name,
          parentGroupId: parentId
        )
        await MainActor.run{
          addGroupResult = .idle()
          addGroupEvent = .push(.added)
        }
      } catch {
        var errString = ""
        if let validationError = error as? ValidationError {
          switch validationError {
            case .EmptyKey:
              errString = "Translation group name cannot be empty"
            case .AlreadyExists:
              errString = "Translation group already exists, please use a different name"
          }
        }
        
        await MainActor.run {
          addGroupResult = 
            .failure(error: "Failed to add translation group - \(errString)" )
        }
      }
      fetchGroups(workspaceId: workspaceId)
    }
  }
}
