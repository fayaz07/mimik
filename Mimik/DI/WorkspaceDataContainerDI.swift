//
//  WorkspaceDataContainerDI.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import Factory
import CoreData

extension Container {
  var workspaceLocalSource: Factory<WorkspaceLocalDataSource> {
    self { WorkspaceLocalDataSource(context: self.managedObjectContext()) }
  }
  
  var workspaceRepository: Factory<WorkspaceRepository> {
    self {
      WorkspaceRepositoryImpl(
        localSource: self.workspaceLocalSource(),
        langRepo: self.langRepo(),
      )
    }
  }
  
  var createUsecase: Factory<CreateWorkspaceUsecase> {
    self { CreateWorkspaceUsecase(repo: self.workspaceRepository()) }
  }
  
  var getUsecase: Factory<GetWorkspaceUsecase> {
    self { GetWorkspaceUsecase(repo: self.workspaceRepository()) }
  }
  
  var switchDefLangUsecase: Factory<SwitchDefaultLanguageUsecase> {
    self { SwitchDefaultLanguageUsecase(repo: self.workspaceRepository()) }
  }
}
