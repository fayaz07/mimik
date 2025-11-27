//
//  TranslationContainerDI.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//
import Factory

extension Container {
  var translationKeyLocalSource: Factory<WSTranslationKeyLocalDataSource> {
    self {
      WSTranslationKeyLocalDataSource(context: self.managedObjectContext())
    }
  }
  
//  var 
}
