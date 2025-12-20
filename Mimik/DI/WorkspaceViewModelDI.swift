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
  
  var workspaceAppsViewModel: Factory<WSAppsViewModel> {
    self { WSAppsViewModel(repo: self.appsRepository()) }
      .scope(.shared)
  }
  
  var workspaceLanguagesViewModel: Factory<WSLanguagesViewModel> {
    self {
      WSLanguagesViewModel(
        usecase: self.addLangUsecase(),
        getWorkspaceUsecase: self.getUsecase(),
        switchLanguageUsecase: self.switchDefLangUsecase(),
        toggleLangStatusUsecase: self.toggleLangStatusUsecase(),
      )
    }
    .scope(.shared)
  }
  
  var trlsnScreenViewModel: Factory<WSTranslationsViewModel> {
    self {
      WSTranslationsViewModel(
        listUseCase: self.listTrslnUsecase(),
        createUseCase: self.createTrslnUsecase()
      )
    }
  }
}
