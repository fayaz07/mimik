//
//  NavigationAction.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//

enum NavigationAction {
    case selectSidebar(SidebarRoutes)
    case navigateToWorkspace(WorkspaceRoutes, itemId: String? = nil)
    case navigateToSettings(SettingsRoutes)
}
