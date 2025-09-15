//
//  DashboardViewModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 05/06/25.
//

import Foundation

final class DashboardViewModel: ObservableObject {
  @Published var workspaces: ViewState<[WorkspaceEntity]> = .init(loading: true)
  
  private let workspacesRepo: WorkspaceRepository
  
  init(workspacesRepo: WorkspaceRepository) {
    self.workspacesRepo = workspacesRepo
    
    Task {
      await fetchWorkspaces()
    }
  }
  
  @MainActor
  func fetchWorkspaces() async {
    print("fetching workspaces")

    // Trigger loading state
    workspaces = .loading()
    print("set loading")

    do {
      let result = try await workspacesRepo.getAll()
          
      // Trigger success state
      workspaces = .success(data: result)
      print("fetch complete")

    } catch {
      print("Failed to fetch workspaces: \(error)")
          
      // Trigger error state
      workspaces = .failure(error: "Failed to fetch workspaces")
    }
  }
}
