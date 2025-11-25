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
}
