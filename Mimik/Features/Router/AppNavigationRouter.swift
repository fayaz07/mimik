//
//  NavigationViewModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//
import Foundation
import SwiftUI

class AppNavigationRouter: ObservableObject {
  @Published var path: [Route] = []

  func push(to route: Route, replace: Bool = false) {
    logPath("push(\(routeLabel(route)), replace: \(replace)) - before")
    if replace {
      if !path.isEmpty {
        path.removeLast()
      }
    }
    path.append(route)
    logPath("push - after")
  }

  func setRoot(to route: Route) {
    logPath("setRoot(\(routeLabel(route))) - before")
    popToRoot()
    path.append(route)
    logPath("setRoot - after")
  }

  func pop() {
    logPath("pop() - before")
    guard !path.isEmpty else { return }
    path.removeLast()
    logPath("pop() - after")
  }

  /// Pops multiple levels at once, e.g. jumping back several steps via a
  /// breadcrumb tap instead of one screen at a time.
  func pop(times: Int) {
    logPath("pop(times: \(times)) - before")
    guard times > 0, !path.isEmpty else { return }
    path.removeLast(min(times, path.count))
    logPath("pop(times:) - after")
  }

  func popToRoot() {
    path.removeAll()
  }

  var currentScreen: Route? {
    path.last
  }

  /// Debug-only: a short, readable dump of the current nav stack, printed
  /// before/after every mutation. Lets us see in Xcode's console whether
  /// `path` genuinely lost an entry (a router bug) vs. the stack being
  /// correct and something else rendering the wrong screen.
  private func logPath(_ label: String) {
    #if DEBUG
    let stack = path.map(routeLabel).enumerated()
      .map { "\($0.offset):\($0.element)" }
      .joined(separator: " -> ")
    print("[Router] \(label) | count=\(path.count) | [\(stack)]")
    #endif
  }

  private func routeLabel(_ route: Route) -> String {
    switch route {
      case .splash:
        return "splash"
      case .home:
        return "home"
      case .workspace(let workspaceRoute):
        return "workspace.\(workspaceRouteLabel(workspaceRoute))"
    }
  }

  private func workspaceRouteLabel(_ route: Route.WorkspaceRoute) -> String {
    switch route {
      case .add:
        return "add"
      case .list:
        return "list"
      case .detail(let id):
        return "detail(\(id.uuidString.prefix(6)))"
      case .apps(let appsRoute):
        switch appsRoute {
          case .add:
            return "apps.add"
          case .detail:
            return "apps.detail"
        }
      case .translations(let translationsRoute):
        switch translationsRoute {
          case .editKey(_, let key, _, let parents):
            return "translations.editKey(\(key.key), depth=\(parents.count))"
          case .groupDetail(_, let group, let parents):
            return "translations.groupDetail(\(group.displayLabel), depth=\(parents.count))"
        }
    }
  }
}
