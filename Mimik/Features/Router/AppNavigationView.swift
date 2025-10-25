//
//  AppNavigationView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct AppNavigationView: View {
  
  @EnvironmentObject var router: AppNavigationRouter
  
  var body: some View {
    NavigationStack(path: $router.path) {
      SplashScreen()
        .navigationDestination(for: AppRoute.self) { dest in
          switch dest {
            case .splash:
              SplashScreen()
              
            case .home:
              HomeScreen()
                .navigationBarBackButtonHidden(true)
              
            case .workspace(let workspaceRoute):
              WorkspaceNavigationView(route: workspaceRoute)
          }
        }
    }
  }
}

struct WorkspaceNavigationView: View {
  let route: AppRoute.WorkspaceRoute

  var body: some View {
    switch route {
      case .add:
        CreateWorkspaceScreen()

      case .list:
        WorkspacesListScreen()

      case .detail(let id):
        WorkspaceDetailScreen(id: id)
    }
  }
}

#Preview {
  AppNavigationView()
}
