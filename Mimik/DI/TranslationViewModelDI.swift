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
        detailUsecase: self.trslnGroupDetailUsecase()
      )
    }
  }
}
