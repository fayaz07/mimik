//
//  DIContainer.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 09/06/25.
//

import Factory
import CoreData

extension Container {
  var managedObjectContext: Factory<NSManagedObjectContext> {
    self { DataController.shared.viewContext }
  }
  
  var workspaceLocalSource: Factory<WorkspaceLocalDataSource> {
    self { WorkspaceLocalDataSource(context: self.managedObjectContext()) }
  }
  
  var workspaceRepository: Factory<WorkspaceRepository> {
    self { WorkspaceRepositoryImpl(localSource: self.workspaceLocalSource()) }
  }

  var dashboardViewModel: Factory<DashboardViewModel> {
    self { DashboardViewModel(workspacesRepo: self.workspaceRepository()) }
      .scope(.shared) // optional: .shared or .singleton
  }
}

