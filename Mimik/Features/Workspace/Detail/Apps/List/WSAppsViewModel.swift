//
//  WorkspaceAppsViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import Foundation

@Observable
final class WSAppsViewModel {
  var apps: ViewState<[WSAppDTO]> = .init(loading: true)
  
  private let repo: WSAppsRepo
  
  init(repo: WSAppsRepo) {
    self.repo = repo
  }
  
  func fetchWorkspaceApps(workspaceId: UUID) {
    apps = .loading()
    Task {
      do {
        let result = try await repo.getByWorkspaceId(workspaceId: workspaceId)
        await MainActor.run {
          apps = .success(data: result)
        }
      } catch {
        await MainActor.run {
          apps = .failure(error: "Failed to fetch workspace apps")
        }
      }
    }
  }
}
