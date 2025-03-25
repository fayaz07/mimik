//
//  SidebarItem.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//


// Define your sidebar items
enum SidebarItem: Hashable, CaseIterable, Identifiable {
  var id: Self { self }

  case dashboard
  case workspaces
  case settings
  
  var title: String {
    switch self {
      case .dashboard:
        return "sidebar.dashboard"
      case .workspaces:
        return "sidebar.workspaces"
      case .settings:
        return "sidebar.settings"
    }
  }
}
