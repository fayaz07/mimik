//
//  WorkspaceRouter.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//

import Foundation
import Combine

final class WorkspaceRouter: ObservableObject {
  @Published var currentRoute: WorkspaceRoutes = .list
   
  // Navigation history for more complex back navigation
  private var navigationHistory: [WorkspaceRoutes] = [.list]
   
  func navigate(to route: WorkspaceRoutes) {
    navigationHistory.append(currentRoute)
    currentRoute = route
  }
   
  func navigateBack() {
    if navigationHistory.count > 1 {
      navigationHistory.removeLast()
      currentRoute = navigationHistory.last ?? .list
    }
  }
   
  func navigateToRoot() {
    navigationHistory = [.list]
    currentRoute = .list
  }
}
