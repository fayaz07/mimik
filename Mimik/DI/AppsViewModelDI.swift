//
//  AppsViewModelDI.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import Factory

extension Container {
  var addAppViewModel: Factory<AddAppViewModel> {
    self { AddAppViewModel(usecase: self.addAppUsecase()) }
      .scope(.shared)
  }
}
