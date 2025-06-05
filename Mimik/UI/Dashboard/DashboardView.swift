//
//  DashboardView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct DashboardView: View {
  
  @FetchRequest(sortDescriptors: []) var workspaces: FetchedResults<Workspace>
  @Environment(\.managedObjectContext) var moc
  
  var body: some View {
    content
      .navigationTitle(LocalizedStringKey(SidebarItem.dashboard.title))
  }
  
  var content: some View {
      
    VStack {
      ForEach(workspaces, id: \.objectID) { workspace in
        Text(workspace.name)
      }
      
      Button(
        action: {
          debugPrint(workspaces)
          let newWorkspace = Workspace(context: moc)
          newWorkspace.name = "New Workspace with random name \(UUID().uuidString)"
          try? moc.save()
        },
        label: {
          Text("Tap Here!")
        }
      )
    }.onAppear {
      for workspace in workspaces {
        debugPrint(workspace.objectID, workspace.id.uuidString)
      }
    }
  }
  
}

#Preview {
  DashboardView()
}
