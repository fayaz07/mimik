//
//  CreateWorkspaceVM.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/08/25.
//

import Foundation

@Observable
class CreateWorkspaceVM {
  
  private let workspaceRepository: WorkspaceRepository
    
  init(workspaceRepository: WorkspaceRepository) {
    self.workspaceRepository = workspaceRepository
  }
  
  var name: String = ""
  var description: String = ""

  var nameError: String? = nil
  var descriptionError: String? = nil
  
  var viewState: ViewState<Void> = ViewState.idle()
  var saveError: String? = nil
  
  private func validateForm() -> Bool {
    var hasError: Bool = false
    if name.isEmpty {
      nameError = "Name is required"
      hasError = true
    } else {
      nameError = nil
    }
    
    if description.isEmpty {
      descriptionError = "Description is required"
      hasError = true
    } else {
      descriptionError = nil
    }
    
    return !hasError
  }
  
  func isNameAlreadyUsed() async throws -> Bool {
    return !(try await workspaceRepository.findByName(name: name).isEmpty)
  }
  
  func saveWorkspace() {
    if !validateForm() {
      return
    }
  
    Task {
      do {
        let nameUsed = try await isNameAlreadyUsed()
        
        if nameUsed {
          self.nameError = "Name is already used"
          return
        }
      } catch {
        // ignore
      }
      
      do {
        try await workspaceRepository
          .create(name: name, description: description)
        name = ""
        description = ""
      } catch {
        // will handle later
        // log
        print("Error creating workspace: \(error)")
      }
    }
  }
}
