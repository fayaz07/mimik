//
//  WorkspaceController.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 23/05/25.
//

import CoreData
import Foundation

class DataController : ObservableObject {
  static let shared = DataController()

  let container = NSPersistentContainer(name: "AppModels")
  
  init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
        
      if let storeURL = description.url {
        try? self.container.persistentStoreCoordinator.destroyPersistentStore(
          at: storeURL,
          ofType: NSSQLiteStoreType
        )
      }
    }
  }
  
  var viewContext: NSManagedObjectContext {
    container.viewContext
  }
}
