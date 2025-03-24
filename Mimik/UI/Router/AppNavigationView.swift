//
//  AppNavigationView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct AppNavigationView: View {
    @State private var selectedSidebarItem: SidebarItem = .dashboard
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedSidebarItem) {
                NavigationLink(value: SidebarItem.dashboard) {
                    Label("Dashboard", systemImage: "gearshape")
                }
            }.navigationTitle(APP_NAME)
        } detail: {
            NavigationStack(path: $path) {
//                Group {
//                    switch selectedSidebarItem {
//                    case .dashboard:
                        DashboardView()
//                    }
//                        .navigationTitle(selectedSidebarItem?.description ?? "")
//                        .navigationSubtitle("Settings") // Optional subtitle
//                }
            }
        }
    }
}

#Preview {
    AppNavigationView()
}
