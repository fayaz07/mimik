//
//  NavigationViewModel.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/06/25.
//
import Foundation
import SwiftUI

class AppNavigationRouter: ObservableObject {
  @Published var path: [AppRoute] = []
   
  func push(to route: AppRoute, replace: Bool = false) {
//    print("push to: \(route)")
    if replace {
//      print("replace")
      if !path.isEmpty {
//        print("not empty")
        path.removeLast()
      }
    }
    path.append(route)
//    print("after push")
  }

  func setRoot(to route: AppRoute) {
//    print("setRoot to: \(route)")
    popToRoot()
    path.append(route)
  }
      
  func pop() {
    guard !path.isEmpty else { return }
    path.removeLast()
  }

  func popToRoot() {
    path.removeAll()
  }
  
  var currentScreen: AppRoute? {
    path.last
  }
}
