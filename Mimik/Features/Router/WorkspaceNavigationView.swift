//
//  WorkspaceNavigationView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import SwiftUI

struct WorkspaceNavigationView: View {
  let route: Route.WorkspaceRoute

  var body: some View {
    switch route {
      case .add:
        CreateWorkspaceScreen()

      case .list:
        WorkspacesListScreen()

      case .detail(let id):
        WorkspaceDetailScreen(id: id)
        
      case .apps(let route):
        WorkspaceAppsNavigationView(route: route)
    }
  }
}

struct WorkspaceAppsNavigationView: View {
  let route: Route.WorkspaceRoute.AppsRoute
  
  var body: some View {
    switch route {
      case .add(let id):
        AddAppScreen(workspaceId: id)
        
      case .detail(let id):
        VStack{ Text("Detail") }
//        WorkspaceAppDetailScreen(appId: id)
    }
  }
}
