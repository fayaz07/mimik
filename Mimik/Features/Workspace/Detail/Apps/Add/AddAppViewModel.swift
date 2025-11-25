//
//  AddAppViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

import Foundation

@Observable
class AddAppViewModel {
  
  private let usecase: AddAppUseCase
    
  init(usecase: AddAppUseCase) {
    self.usecase = usecase
  }
  
  var name: String = ""
  var description: String = ""
  var selectedPlatform: MimikPlatformType?

  var nameError: String? = nil
  var descriptionError: String? = nil
  var selectedPlatformError: String? = nil
  
  var viewState: ViewState<Void> = ViewState.idle()
  var viewEvents: ViewEvent<AddAppEvents> = .init(
    isError: false,
    data: nil
  )
 
  func getPlatforms() -> [MimikPlatformType] {
    return SupportedPlatforms.list
  }
  
  func clearSelectedPlatformError() {
    selectedPlatformError = nil
  }
  
  private func validateForm(workspaceId: UUID) -> Bool {
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
    
    if selectedPlatform == nil {
      selectedPlatformError = "Platform is required"
      hasError = true
    } else {
      selectedPlatformError = nil
    }
    
    return !hasError
  }
    
  func saveWorkspace(workspaceId: UUID) {
    if selectedPlatform == nil {
      selectedPlatformError = "Platform is required"
      return
    } else {
      selectedPlatformError = nil
    }
    
    Task {
      do {
        let (result, nameErr, descriptionErr, otherErr) = try await usecase
          .execute(
            name: name,
            description: description,
            workspaceId: workspaceId,
            appPlatformId: selectedPlatform!.id
          )
        var hasErr = false
        if !nameErr.isEmpty {
          self.nameError = nameErr
          hasErr = true
        }
        
        if !descriptionErr.isEmpty {
          self.descriptionError = descriptionErr
          hasErr = true
        }
        
        if otherErr != nil || hasErr {
          self.viewState = .failure(error: otherErr ?? "")
          return
        }
                
        name = ""
        description = ""
        viewState = .success(data: ())
        viewEvents = .push(AddAppEvents.created(id: result!.id))
      } catch {
        viewState =
          .failure(error: "Failed to create workspace, please try again")
      }
    }
  }
}
