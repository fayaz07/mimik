//
//  CreateWorkspaceUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

class CreateWorkspaceUsecase {
  private let repo: WorkspaceRepository
  
  init(repo: WorkspaceRepository) {
    self.repo = repo
  }
  
  private func isNameAlreadyUsed(name: String) async throws -> Bool {
    return !(try await repo.findByName(name: name).isEmpty)
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
    description: String
  ) async throws -> (WorkspaceDTO?, String, String, String?) {
    
    let (formValid, nameError, descriptionError) = validate(name: name, desc: description)
    if !formValid {
      return (nil, nameError ?? "", descriptionError ?? "", "Please fill in all fields")
    }
    
    do {
      let nameUsed = try await isNameAlreadyUsed(name: name)
      
      if nameUsed {
        return (nil, "Name is already used", "", nil)
      }
    } catch {
      // ignore
    }
    
    do {
      let result = try await repo
        .create(name: name, description: description)
      return (result, "", "", nil)
    } catch {
      return (nil, "", "", "Something went wrong")
    }
  }
}
