//
//  WorkspaceAppsViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import Foundation

@Observable
final class WorkspaceAppsViewModel {
  var apps: ViewState<[WorkspaceAppDTO]> = .init(loading: true)
  
  private let repo: WorkspaceAppsRepository
  
  init(repo: WorkspaceAppsRepository) {
    self.repo = repo
  }
  
  func fetchWorkspaceApps(workspaceId: UUID) {
    print("Fetching workspace apps")
    apps = .loading()
    Task {
      do {
        let result = try await repo.getByWorkspaceId(workspaceId: workspaceId)
        await MainActor.run {
          apps = .success(data: result)
        }
        print("fetched, count: \(result.count)")
      } catch {
        await MainActor.run {
          apps = .failure(error: "Failed to fetch workspace apps")
        }
        print("error: \(error) ")
      }
    }
  }
}
