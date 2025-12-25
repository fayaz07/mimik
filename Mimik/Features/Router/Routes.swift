//
//  AppRoutes.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 07/09/25.
//
import CoreData

enum Route: Hashable {
  case splash
  case home
  case workspace(WorkspaceRoute)

  enum WorkspaceRoute: Hashable {
    case add
    case list
    case detail(id: UUID)

    case apps(AppsRoute)
    enum AppsRoute: Hashable {
      case add(workspaceId: UUID)
      case detail(id: UUID)
    }
    
    case translations(TranslationsRoute)
    enum TranslationsRoute: Hashable {
      case addGroup(workspaceId: UUID, parentGroupId: UUID?, groups: [TranslationGroupDTO])
    }
  }
}
