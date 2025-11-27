//
//  WorkspaceSettingsEvents.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 15/10/25.
//

enum WSSettingsEvents: Equatable {
  case deleted
  case deleteFailed(String)
  
  case nameChanged(String)
}
