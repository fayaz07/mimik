//
//  WorkspaceView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct WorkspacesListView: View {
   
  @EnvironmentObject private var router: WorkspaceRouter
  
  var body: some View {
    Text("Hello, Workspaces!")
      
    Button("Add Workspace") {
      print("🔍 Button tapped")
      print("🔍 Router type: \(type(of: router))")
      print("🔍 Current route: \(router.currentRoute)")
      Task { @MainActor in
        router.navigate(to: .create)
      }
    }.onAppear { print("✅ ListView found router") }
  }
}

#Preview {
  WorkspacesListView()
}

//
//  WorkspaceModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 25/03/25.
//

//import SwiftUI
//import SwiftData
//
//@Model
//final class WorkspaceModel {
//  @Attribute(.unique) var id: UUID = UUID()
//  
//  var name: String = ""
//  var deleted: Bool = false
//  var lastAccessed: Date = Date()
//  var created: Date = Date()
//  
//  init(name: String, deleted: Bool, lastAccessed: Date, created: Date) {
//    self.name = name
//    self.deleted = deleted
//    self.lastAccessed = lastAccessed
//    self.created = created
//  }
//}
