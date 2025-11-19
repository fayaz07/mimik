//
//  CreateWorkspaceVM.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/08/25.
//

import Foundation

@Observable
final class CreateWorkspaceVM {
  
  private let createUsecase: CreateWorkspaceUsecase
    
  init(usecase: CreateWorkspaceUsecase) {
    self.createUsecase = usecase
  }
  
  var name: String = ""
  var description: String = ""

  var nameError: String? = nil
  var descriptionError: String? = nil
  
  var viewState: ViewState<Void> = ViewState.idle()
  var viewEvents: ViewEvent<CreateWorkspaceEvents> = .init(isError: false, data: nil)
    
  func saveWorkspace() {
    Task {
      do {
        let (result, nameErr, descErr, err) = try await createUsecase.execute(name: name, description: description)
        if result == nil {
          nameError = nameErr
          descriptionError = descErr
          viewState = .failure(error: err ?? "Failed to create workspace, please try again")
          return
        }
        name = ""
        description = ""
        viewState = .success(data: ())
        viewEvents = .push(CreateWorkspaceEvents.created(result!.id))
      } catch {
        viewState = .failure(error: "Failed to create workspace, please try again")
      }
    }
  }
}
