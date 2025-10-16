//
//  WorkspaceSettingsViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import Foundation
import CoreData

@Observable
class WorkspaceSettingsViewModel {
  private let workspaceRepository: WorkspaceRepository
  
  init(workspaceRepository: WorkspaceRepository) {
    self.workspaceRepository = workspaceRepository
  }
  
  var deleteState: ViewState<Void> = ViewState.idle()
  var events: ViewEvent<WorkspaceSettingsEvents> = .init(
    isError: false,
    data: nil
  )
  
  func deleteWorkspace(id: UUID) {
    deleteState = .loading()
    
    Task {
      do {
        try await workspaceRepository.delete(id: id)
        deleteState = .success(data: ())
        events = .push(WorkspaceSettingsEvents.deleted)
      } catch {
        deleteState = .failure(error: "Unable to delete workspace")
        
        try? await Task.sleep(nanoseconds: 4_000_000_000)
        deleteState = .idle()
      }
    }
  }
}
