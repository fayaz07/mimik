//
//  WorkspaceModule.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//

import SwiftUI

struct WorkspaceModule: View {
  @StateObject private var router = WorkspaceRouter()
  
  var body: some View {
    NavigationStack {
      switch router.currentRoute {
      case .list:
        WorkspacesListView()
      case .create:
        CreateWorkspaceView()
      case .detail:
        Text("Detail")
      }
    }
    .environmentObject(router)
  }
}

#Preview {
  WorkspaceModule()
}
