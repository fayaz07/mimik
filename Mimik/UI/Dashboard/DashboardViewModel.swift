//
//  DashboardViewModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 05/06/25.
//

import Foundation

final class DashboardViewModel: ObservableObject {
  @Published var workspaces: [WorkspaceEntity] = []
  
  private let workspacesRepo: WorkspaceRepository
  
  init(workspacesRepo: WorkspaceRepository) {
    self.workspacesRepo = workspacesRepo
  }
  
  func fetchWorkspaces() async throws {
    workspaces = try await workspacesRepo.getAll()
  }
}
