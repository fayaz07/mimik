//
//  TranslationViewModelDI.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 05/05/26.
//

import Factory

extension Container {
  var trslnGroupDetailViewModel: Factory<TrslnGroupDetailViewModel> {
    self {
      TrslnGroupDetailViewModel(
        detailUsecase: self.trslnGroupDetailUsecase(),
        getWorkspaceUsecase: self.getUsecase(),
        langUsecase: self.addLangUsecase(),
        valueUsecase: self.trslnValueUsecase()
      )
    }
  }

  var editTranslationsViewModel: Factory<EditTranslationsViewModel> {
    self {
      EditTranslationsViewModel(
        getWorkspaceUsecase: self.getUsecase(),
        langUsecase: self.addLangUsecase(),
        valueUsecase: self.trslnValueUsecase()
      )
    }
  }
}
