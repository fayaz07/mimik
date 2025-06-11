//
//  WorkspaceRouter.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//

import Foundation

final class WorkspaceRouter {
  @Published var currentRoute: WorkspaceRoutes = .list
  
  func navigate(to route: WorkspaceRoutes) {
      currentRoute = route
  }
  
  func navigateBack() {
      switch currentRoute {
      case .create, .detail:
          currentRoute = .list
      case .list:
          break
      }
  }
}
