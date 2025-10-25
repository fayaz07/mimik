//
//  DashboardViewModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 05/06/25.
//

import Foundation

final class HomeViewModel: ObservableObject {
  @Published var workspaces: ViewState<[WorkspaceDTO]> = .init(loading: true)
  
  private let workspacesRepo: WorkspaceRepository
  
  init(workspacesRepo: WorkspaceRepository) {
    self.workspacesRepo = workspacesRepo
  }
  
  func fetchWorkspaces() {
    workspaces = .loading()
    Task {
      do {
        let result = try await workspacesRepo.getAll()
        await MainActor.run {
          workspaces = .success(data: result)
        }
        
        result.forEach { it in
          print("Workspace: \(it.name) - \(it.lastAccessed)")
        }
      } catch {
        await MainActor.run {
          workspaces = .failure(error: "Failed to fetch workspaces")
        }
      }
    }
  }
}
