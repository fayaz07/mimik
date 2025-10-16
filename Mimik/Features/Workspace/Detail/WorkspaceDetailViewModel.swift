//
//  WorkspaceDetailViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import Foundation
import CoreData

@Observable
class WorkspaceDetailViewModel {
  private let workspaceRepository: WorkspaceRepository
    
  init(workspaceRepository: WorkspaceRepository) {
    self.workspaceRepository = workspaceRepository
  }
  
  var viewState: ViewState<WorkspaceEntity> = ViewState.idle()
  
  func fetchWorkspaceById(id: UUID) {
    Task {
      viewState = .loading()
      do {
        let result = try await workspaceRepository.getById(id: id)
        if result != nil {
          viewState = .success(data: result!)
        } else {
          viewState = .failure(error: "Workspace not found")
        }
      } catch {
        viewState = .failure(error: "Failed to load data")
      }
    }
  }
}
