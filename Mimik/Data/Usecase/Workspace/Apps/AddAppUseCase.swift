//
//  CreateWorkspaceAppUseCase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//
import CoreData

class AddAppUseCase {
  private let workspacesRepo: WorkspaceRepository
  private let appsRepo: WSAppsRepo
  
  init(repo: WorkspaceRepository, appsRepo: WSAppsRepo) {
    self.workspacesRepo = repo
    self.appsRepo = appsRepo
  }
  
  private func isNameAlreadyUsed(
    name: String,
    workspaceId: UUID,
    appPlatformId: String,
  ) async throws -> Bool {
    return !(try await appsRepo.findByName(
      name: name,
      workspaceId: workspaceId,
      appPlatformId: appPlatformId
    ).isEmpty)
  }
  
  func validate(name: String, desc: String) -> (Bool, String?, String?) {
    var nameError: String?
    var descriptionError: String?
    var hasError: Bool = false

    if name.isEmpty {
      nameError = "Name is required"
      hasError = true
    }
    
    if desc.isEmpty {
      descriptionError = "Description is required"
      hasError = true
    }
    
    return (!hasError, nameError, descriptionError)
  }
  
  /**
   * Returns - result, nameError, descriptionError, error
   */
  func execute(
    name: String,
    description: String,
    workspaceId: UUID,
    appPlatformId: String,
  ) async throws -> (WSAppDTO?, String, String, String?) {
    
    let (formValid, nameError, descriptionError) = validate(name: name, desc: description)
    if !formValid {
      return (nil, nameError ?? "", descriptionError ?? "", "Please fill in all fields")
    }
    
    do {
      let nameUsed = try await isNameAlreadyUsed(name: name, workspaceId: workspaceId, appPlatformId: appPlatformId)
      
      if nameUsed {
        return (nil, "Name is already used", "", nil)
      }
    } catch {
      // ignore
    }
    
    do {
      let result = try await appsRepo
        .create(
          name: name,
          description: description,
          workspaceId: workspaceId,
          appPlatformId: appPlatformId
        )
      return (result, "", "", nil)
    } catch {
      return (nil, "", "", "Something went wrong")
    }
  }
}
