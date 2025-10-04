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
            case AppRoutes.dashboard:
              DashboardScreen()
                .navigationBarBackButtonHidden(true)
            
              
            case AppRoutes.Workspace.add:
              CreateWorkspaceScreen()
            case AppRoutes.Workspace.list:
              WorkspacesListScreen()
              
              
            default:
              SplashScreen()
          }
        }
    }
  }
}

#Preview {
  AppNavigationView()
}
