//
//  TranslationsNavigator.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/10/26.
//

import Foundation

/// Local, tab-scoped navigation for the Translations tab.
///
/// Pushing nested groups / edit-key through the app-wide
/// `AppNavigationRouter` would replace the whole `WorkspaceDetailScreen`
/// (sidebar included), since that router drives the single app-level
/// `NavigationStack` declared in `AppNavigationView`. This navigator instead
/// backs a `NavigationStack` embedded *inside* the Translations tab's own
/// detail content (see `WSTranslationsScreen`), so drilling into a subgroup
/// keeps the workspace sidebar (Dashboard/Apps/Languages/...) visible the
/// whole time, instead of covering it with a full-screen push.
@Observable
class TranslationsNavigator {
  var path: [Route.WorkspaceRoute.TranslationsRoute] = []

  func push(to route: Route.WorkspaceRoute.TranslationsRoute) {
    path.append(route)
  }

  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  /// Pops multiple levels at once, e.g. jumping back several steps via a
  /// breadcrumb tap instead of one screen at a time.
  func pop(times: Int) {
    guard times > 0, !path.isEmpty else { return }
    path.removeLast(min(times, path.count))
  }

  func popToRoot() {
    path.removeAll()
  }

  var currentScreen: Route.WorkspaceRoute.TranslationsRoute? {
    path.last
  }
}
