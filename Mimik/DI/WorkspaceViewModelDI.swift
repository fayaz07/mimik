//
//  WorkspaceDIContainer.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

import Factory
import CoreData

extension Container {
  var createWorkspaceViewModel: Factory<CreateWorkspaceVM> {
    self { CreateWorkspaceVM(usecase: self.createUsecase()) }
      .scope(.shared)
  }
  
  var workspaceAppsViewModel: Factory<WorkspaceAppsViewModel> {
    self { WorkspaceAppsViewModel(repo: self.appsRepository()) }
      .scope(.shared)
  }
  
  var workspaceLanguagesViewModel: Factory<WorkspaceLanguagesViewModel> {
    self { WorkspaceLanguagesViewModel(usecase: self.addLangUsecase()) }
      .scope(.shared)
  }
}
