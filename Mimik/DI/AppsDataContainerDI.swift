//
//  AppsDataContainerDI.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import Factory
import CoreData

extension Container {
  var appsLocalSource: Factory<WorkspaceAppsLocalDataSource> {
    self { WorkspaceAppsLocalDataSource(context: self.managedObjectContext()) }
  }
  
  var appsRepository: Factory<WorkspaceAppsRepository> {
    self {
      WorkspaceAppsRepositoryImpl(localSource: self.appsLocalSource())
    }
  }
  
  var addAppUsecase: Factory<AddAppUseCase> {
    self {
      AddAppUseCase(
        repo: self.workspaceRepository(),
        appsRepo: self.appsRepository()
      )
    }
  }  
}
