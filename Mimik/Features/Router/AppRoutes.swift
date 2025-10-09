//
//  AppRoutes.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 07/09/25.
//
import CoreData

enum AppRoute: Hashable {
  case splash
  case dashboard
  case workspace(WorkspaceRoute)

  enum WorkspaceRoute: Hashable {
    case add
    case list
    case detail(id: UUID)
  }
}
