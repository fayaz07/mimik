//
//  AppNavigationView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct AppNavigationView: View {
  @EnvironmentObject private var navRouter: AppNavigationRouter
  
  var body: some View {
    NavigationSplitView {
      List(
        SidebarRoutes.allCases,
        selection: Binding(
          get: { navRouter.selectedSidebarRoute },
          set: { newValue in
            Task { @MainActor in
              navRouter.selectedSidebarRoute = newValue
            }
          }
        )
      ) { menuItem in
        NavigationLink(value: menuItem) {
          Label(LocalizedStringKey(menuItem.title), systemImage: "gearshape")
        }
      }
    } detail: {
      switch navRouter.selectedSidebarRoute {
        case .dashboard: DashboardView()
        case .workspaces: WorkspaceModule()
        case .settings: SettingsView()
        case .none: Text("Hello!")
      }
    }
  }
}

#Preview {
  AppNavigationView()
}
