//
//  AppsDataContainerDI.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import Factory
import CoreData

extension Container {
  var appsLocalSource: Factory<WSAppsLocalDataSource> {
    self { WSAppsLocalDataSource(context: self.managedObjectContext()) }
  }
  
  var appsRepository: Factory<WSAppsRepo> {
    self {
      WSAppsRepoImpl(localSource: self.appsLocalSource())
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
