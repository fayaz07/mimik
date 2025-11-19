//
//  WorkspaceDIContainer.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

import Factory
import CoreData

extension Container {
  var createUsecase: Factory<CreateWorkspaceUsecase> {
    self {
      CreateWorkspaceUsecase(repo: self.workspaceRepository())
    }
  }
  
  var createWorkspaceViewModel: Factory<CreateWorkspaceVM> {
    self { CreateWorkspaceVM(usecase: self.createUsecase()) }
      .scope(.shared)
  }
}
