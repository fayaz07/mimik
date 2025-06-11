//
//  NavigationState.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 10/06/25.
//

struct NavigationState {
  var workspaceView: WorkspaceRoutes
  var settingsView: SettingsRoutes
  
  var selectedSidebarItem: SidebarRoutes?
  var selectedItemId: String?
    
  init() {
    self.selectedSidebarItem = .dashboard
    self.workspaceView = .list
    self.settingsView = .general
    self.selectedItemId = nil
  }
}
