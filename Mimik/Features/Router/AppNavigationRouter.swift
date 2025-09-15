//
//  NavigationViewModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//
import Foundation
import SwiftUI

class AppNavigationRouter: ObservableObject {
  @Published var path: NavigationPath = NavigationPath()
   
  func push(to route: AppRoute, replace: Bool = false) {
    if replace {
      if !path.isEmpty {
        path.removeLast()
      }
    }
    path.append(route)
  }

  func setRoot(to route: AppRoute) {
    popToRoot()
    path.append(route)
  }
      
  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  func popToRoot() {
    path.removeLast(path.count)
  }
}
