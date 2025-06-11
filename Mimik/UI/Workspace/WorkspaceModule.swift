//
//  WorkspaceModule.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//

import SwiftUI
import Factory

struct WorkspaceModule: View {
  
  @Injected(\.workspaceRouter) private var router
  
  var body: some View {
    NavigationStack {
      switch router.currentRoute {
        case .list:
          WorkspacesListView()
        case .create:
          CreateWorkspaceView()
//        case .detail(let id):
//          Text("Detail \(id)")
          //          WorkspaceDetailView(workspaceId: id)
        case .detail:
          Text("Detail")
      }
    }
  }
}

#Preview {
  WorkspaceModule()
}
