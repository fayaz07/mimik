//
//  DashboardView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI
import Factory

struct DashboardScreen: View {
  
  @InjectedObject(\.dashboardViewModel) private var viewModel
  @Environment(\.managedObjectContext) var moc
    
  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top){
        content
          .navigationTitle(LocalizedStringKey(SidebarRoutes.dashboard.title))
        Spacer()
      }
      Spacer()
    }.padding()

  }
    
  var content: some View {
    VStack {
      ViewStateUIBuilder(
        state: viewModel.workspaces,
        forLoading: {
          ProgressView()
        },
        forError: { error in
          Text("Error: \(error)")
        },
        forData: { items in
          VStack(alignment: .leading) {
            if items.isEmpty {
              Text("No items found.")
            } else {
              List(items, id: \.self) { item in
                Text(item.name)
              }
            }
          }
        },
        forNoData: {
          Text("No items found.")
        }
      )
      
      Button(
        action: {
          //          let newWorkspace = Workspace(context: moc)
          //          newWorkspace.name = "New Workspace with random name \(UUID().uuidString)"
          //          newWorkspace.id = UUID()
          //          try? moc.save()
        },
        label: {
          Text("Add new Workspace")
        }
      )
    }
  }
    
}

#Preview {
  DashboardScreen()
}
