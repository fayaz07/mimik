//
//  SidebarItem.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

enum SidebarRoutes: Hashable, CaseIterable, Identifiable {
  var id: Self { self }
  
  case dashboard
  case settings
  case workspaces
  
  var title: String {
    switch self {
    case .dashboard:
      return "screen.dashboard"
    case .settings:
      return "screen.settings"
    case .workspaces:
      return "screen.workspaces"
    }
  }
}
