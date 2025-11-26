//
//  WorkspaceDetailSideRoutes.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 13/10/25.
//

enum WorkspaceDetailRoute: Hashable {
  case dashboard
  case apps
  case variables
  case languages
  case translations
  case users
  case settings
}

extension WorkspaceDetailRoute {
  func title() -> String {
    switch self {
      case .dashboard:
        return "Dashboard"
      case .apps:
        return "Apps"
      case .variables:
        return "Variables"
      case .languages:
        return "Languages"
      case .translations:
        return "Translations"
      case .users:
        return "Users"
      case .settings:
        return "Settings"
    }
  }
  
  func iconName() -> String {
    switch self {
      case .dashboard:
        return "house"
      case .apps:
        return "apps.iphone"
      case .variables:
        return "text.bubble"
      case .languages:
        return "globe"
      case .translations:
        return "translate"
      case .users:
        return "person.2"
      case .settings:
        return "gearshape"
    }
  }
}
