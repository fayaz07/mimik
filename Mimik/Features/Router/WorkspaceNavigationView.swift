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
        
      case .translations(let route):
        WorkspaceTranslationsNavigationView(route: route)
    }
  }
}

struct WorkspaceAppsNavigationView: View {
  let route: Route.WorkspaceRoute.AppsRoute
  
  var body: some View {
    switch route {
      case .add(let id):
        AddAppScreen(workspaceId: id)
        
      case .detail(let app):
        AppDetailScreen(app: app)
    }
  }
}

struct WorkspaceTranslationsNavigationView: View {
  let route: Route.WorkspaceRoute.TranslationsRoute
  
  var body: some View {
    switch route {
      case .editKey(let workspaceId, let key, let groupName, let parentGroups):
        EditTranslationsScreen(
          workspaceId: workspaceId,
          key: key,
          groupName: groupName,
          parentGroups: parentGroups
        )

      case .groupDetail(let workspaceId, let group, let parentGroups):
        TrslnGroupDetailView(
          workspaceId: workspaceId,
          currentGroup: group,
          parentGroups: parentGroups
        )
    }
  }
}
