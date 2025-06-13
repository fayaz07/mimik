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
    VStack {
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
