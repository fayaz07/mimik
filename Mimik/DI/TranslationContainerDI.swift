//
//  TranslationContainerDI.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//
import Factory

extension Container {
  var trslnKeyLocalSource: Factory<WSTranslationKeyLocalDataSource> {
    self {
      WSTranslationKeyLocalDataSource(context: self.managedObjectContext())
    }
  }
  
  var trslnGroupLocalSource: Factory<WSTranslationGroupLocalDataSource> {
    self {
      WSTranslationGroupLocalDataSource(context: self.managedObjectContext())
    }
  }
  
  var trslnValueLocalSource: Factory<WSTranslationValueLocalDataSource> {
    self {
      WSTranslationValueLocalDataSource(context: self.managedObjectContext())
    }
  }
  
  var trslnRepo: Factory<WSTranslationRepo> {
    self {
      WSTranslationRepoImpl(
        localKeySource: self.trslnKeyLocalSource(),
        localGroupSource: self.trslnGroupLocalSource(),
        localValueSource: self.trslnValueLocalSource()
      )
    }
  }
  
  var listTrslnUsecase: Factory<ListTranslationsUsecase> {
    self {
      ListTranslationsUsecase(repo: self.trslnRepo())
    }
  }
  
  var createTrslnUsecase: Factory<CreateTranslationUsecase> {
    self {
      CreateTranslationUsecase(repo: self.trslnRepo())
    }
  }

  var renameTrslnGroupUsecase: Factory<RenameTranslationGroupUsecase> {
    self {
      RenameTranslationGroupUsecase(repo: self.trslnRepo())
    }
  }

  var deleteTrslnGroupUsecase: Factory<DeleteTranslationGroupUsecase> {
    self {
      DeleteTranslationGroupUsecase(repo: self.trslnRepo())
    }
  }

  var createTrslnKeyUsecase: Factory<CreateTranslationKeyUsecase> {
    self {
      CreateTranslationKeyUsecase(repo: self.trslnRepo())
    }
  }
  
  var trslnGroupDetailUsecase: Factory<TranslationGroupDetailUsecase> {
    self {
      TranslationGroupDetailUsecase(repo: self.trslnRepo())
    }
  }

  var trslnValueUsecase: Factory<TranslationValueUsecase> {
    self {
      TranslationValueUsecase(repo: self.trslnRepo())
    }
  }
}
