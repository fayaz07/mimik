//
//  DIContainer.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 09/06/25.
//

import Factory
import CoreData

extension Container {
  var managedObjectContext: Factory<NSManagedObjectContext> {
    self { DataController.shared.viewContext }
  }

  var homeViewModel: Factory<HomeViewModel> {
    self { HomeViewModel(workspacesRepo: self.workspaceRepository()) }
      .scope(.shared)
  }
}

