//
//  AppNavigationView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct AppNavigationView: View {
  @State private var path = [String]()
  
  var body: some View {
    NavigationStack(path: $path) {
      SplashScreen()
        .navigationDestination(for: String.self) { dest in
          switch dest {
            case AppRoutes.dashboard:
              DashboardScreen()
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
