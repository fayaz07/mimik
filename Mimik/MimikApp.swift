//
//  MimikApp.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 16/03/25.
//

import SwiftUI
import SwiftData

@main
struct MimikApp: App {
  
  @StateObject private var controller = DataController()
  
  var body: some Scene {
    WindowGroup {
      AppNavigationView()
        .environment(\.managedObjectContext, controller.container.viewContext)
    }
  }
}
