//
//  DashboardView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI
import Factory

struct DashboardView: View {
  
//  @InjectedObject(\.dashboardViewModel) private var viewModel
  @Environment(\.managedObjectContext) var moc
    
  var body: some View {
    content
      .navigationTitle(LocalizedStringKey(SidebarRoutes.dashboard.title))
  }
    
  var content: some View {
        
    VStack {
//      List(viewModel.workspaces, id: \.objectID) { workspace in
//        Text(workspace.name)
//      }
//      .task {
//        try? await viewModel.fetchWorkspaces()
//      }
      
//      Button(
//        action: {
//          //          let newWorkspace = Workspace(context: moc)
//          //          newWorkspace.name = "New Workspace with random name \(UUID().uuidString)"
//          //          newWorkspace.id = UUID()
//          //          try? moc.save()
//        },
//        label: {
//          Text("Tap Here!")
//        }
//      )
    }
  }
    
}

#Preview {
  DashboardView()
}
