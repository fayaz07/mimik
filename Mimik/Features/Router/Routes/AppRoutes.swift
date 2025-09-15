//
//  AppRoutes.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 07/09/25.
//

typealias AppRoute = String

struct AppRoutes {
  static let splash: AppRoute = "/splash"
  static let dashboard: AppRoute = "/dashboard"
  
  struct Workspace {
    static let add: AppRoute = "/workspace/add"
    static let list: AppRoute = "/workspace/list"
  }
}
