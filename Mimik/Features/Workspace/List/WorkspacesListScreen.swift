//
//  WorkspaceView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI
import CoreData
import Factory

struct WorkspacesListScreen: View {
   
  @EnvironmentObject private var router: WorkspaceRouter
  @State private var viewModel: WorkspaceListViewModel
  
  init() {
    self._viewModel = State(
      wrappedValue: WorkspaceListViewModel(
        workspaceRepository: Container.shared.workspaceRepository.resolve()
      )
    )
    
    viewModel.loadWorkspaces()
  }
  
  var body: some View {
    VStack {
      
      // show names of workspaces
      if viewModel.workspaces.isEmpty {
        Text("No workspaces found.")
      } else {
        List(viewModel.workspaces, id: \.self) { item in
          Text(item.name)
        }
      }
      
      Text("Hello, Workspaces!")
      
      Button("Add Workspace") {
        router.navigate(to: .create)
      }
    }
  }
}

#Preview {
  WorkspacesListView()
}
  
