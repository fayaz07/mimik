//
//  AppNavigationView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct AppNavigationView: View {
  @EnvironmentObject private var viewModel: AppNavigationRouter
  
  var body: some View {
    NavigationSplitView {
      List(
        SidebarRoutes.allCases,
        selection: Binding(
          get: { viewModel.selectedSidebarRoute },
          set: { newValue in
            Task { @MainActor in
              viewModel.selectedSidebarRoute = newValue
            }
          }
        )
      ) { menuItem in
        NavigationLink(value: menuItem) {
          Label(LocalizedStringKey(menuItem.title), systemImage: "gearshape")
        }
      }
    } detail: {
      switch viewModel.selectedSidebarRoute {
        case .dashboard: DashboardView()
        case .workspaces: WorkspacesListView()
        case .settings: SettingsView()
        case .none: Text("Hello!")
      }
    }
  }
}

#Preview {
  AppNavigationView()
}
