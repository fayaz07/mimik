//
//  LangContainerDI.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

import Factory

extension Container {
  var langDataSource: Factory<LangDataSource> {
    self { LangDataSource() }
      .scope(.singleton)
  }
  
  var langRepo: Factory<LangRepository> {
    self { LangRepository(dataSource: self.langDataSource()) }
      .scope(.shared)
  }
  
  var workspaceLanguagesLocalDataSource: Factory<WSLanguagesLocalDataSource> {
    self { WSLanguagesLocalDataSource(context: self.managedObjectContext()) }
  }
  
  var workspaceLangRepo: Factory<WSLanguagesRepo> {
    self {
      WSLanguagesRepoImpl(localSource: self.workspaceLanguagesLocalDataSource())
    }
  }
  
  var addLangUsecase: Factory<AddLanguageUsecase> {
    self {
      AddLanguageUsecase(
        repo: self.workspaceLangRepo(),
        langRepo: self.langRepo()
      )
    }
    .scope(.shared)
  }
  
  var toggleLangStatusUsecase: Factory<ToggleLangStatusUsecase> {
    self {
      ToggleLangStatusUsecase(repo: self.workspaceLangRepo())
    }
    .scope(.shared)
  }
}
