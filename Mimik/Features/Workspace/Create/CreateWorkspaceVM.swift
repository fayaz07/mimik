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
    
  init(
    workspaceRepository: WorkspaceRepository
  ) {
    self.workspaceRepository = workspaceRepository
  }
  
  var name: String = ""
  var description: String = ""

  var nameError: String? = nil
  var descriptionError: String? = nil
  
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
  
  func saveWorkspace() {
    if !validateForm() {
      return
    }
    
    Task {
      do {
        try await workspaceRepository
          .create(name: name, description: description)
        print("Workspace created successfully")
        
      } catch {
        // will handle later
        // log
        print("Error creating workspace: \(error)")
      }
    }
  }
}
