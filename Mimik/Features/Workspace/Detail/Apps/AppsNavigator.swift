//
//  AppsNavigator.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import Foundation

/// Local, tab-scoped navigation for the Apps tab - mirrors
/// TranslationsNavigator for the exact same reason: pushing "Add App" (or
/// an app's detail screen) through the app-wide `AppNavigationRouter` would
/// replace the whole `WorkspaceDetailScreen`, sidebar included, since that
/// router drives the single app-level `NavigationStack`. This navigator
/// instead backs the Apps tab's own content, so adding or viewing an app
/// keeps the workspace sidebar (Dashboard/Apps/Languages/...) visible the
/// whole time, instead of covering it with a full-screen push.
@Observable
class AppsNavigator {
  var path: [Route.WorkspaceRoute.AppsRoute] = []

  func push(to route: Route.WorkspaceRoute.AppsRoute) {
    path.append(route)
  }

  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  func popToRoot() {
    path.removeAll()
  }

  var currentScreen: Route.WorkspaceRoute.AppsRoute? {
    path.last
  }
}
