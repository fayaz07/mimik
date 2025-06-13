//
//  WorkspaceView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 10/06/25.
//


enum WorkspaceRoutes: String, CaseIterable {
  case list
  case create
  case detail
  
  var title: String {
    switch self {
    case .list:
      return "screen.workspaces.list"
    case .create:
      return "screen.workspaces.create"
    case .detail:
      return "screen.workspaces.detail"
    }
  }
}
