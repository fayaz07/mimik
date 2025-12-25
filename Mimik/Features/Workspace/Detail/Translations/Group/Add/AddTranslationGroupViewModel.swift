//
//  AddTranslationGroupViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 23/12/25.
//

import Foundation
import CoreData

@Observable
class AddTranslationGroupViewModel {
  
  private let createUseCase: CreateTranslationUsecase
  
  init(createUseCase: CreateTranslationUsecase) {
    self.createUseCase = createUseCase
  }
  
  var currentGroupName: String = ""
  var addGroupResult: ViewState<String> = .idle()
  
  @Published @ObservationIgnored var addGroupEvent: ViewEvent<AddTranslationEvents> = .none()
  
  func addGroup(workspaceId: UUID, parentId: UUID? = nil) {
    addGroupResult = .loading()
    Task {
      do {
        _ = try await createUseCase.create(
          workspaceId: workspaceId,
          key: currentGroupName,
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
    }
  }
}
