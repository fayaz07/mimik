//
//  WorkspaceListViewModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 15/08/25.
//

import Foundation

class WorkspaceListViewModel: ObservableObject {
  @Published var workspaces: [WorkspaceEntity] = []
  
  private var workspaceRepository: WorkspaceRepository
  
  init(workspaceRepository: WorkspaceRepository) {
    self.workspaceRepository = workspaceRepository
  }
  
  func loadWorkspaces() {
    Task {
      do {
        workspaces = try await workspaceRepository.getAll()
      } catch {
        // will handle later
      }
    }
  }
}
