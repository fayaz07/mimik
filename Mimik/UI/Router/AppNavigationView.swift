//
//  AppNavigationView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct AppNavigationView: View {
  @State private var selectedSidebarItem: SidebarItem = .dashboard
  
  var body: some View {
    NavigationSplitView {
      List(selection: $selectedSidebarItem) {
        ForEach(SidebarItem.allCases) { menuItem in
          NavigationLink(value: menuItem) {
            Label(LocalizedStringKey(menuItem.title), systemImage: "gearshape")
          }
        }
      }
    } detail: {
      switch selectedSidebarItem {
        case .dashboard: DashboardView()
        case .workspaces: WorkspacesView()
        case .settings: DashboardView()
      }
    }
  }
}

#Preview {
  AppNavigationView()
}
