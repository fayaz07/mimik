//
//  SettingsRoutes.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 10/06/25.
//

enum SettingsRoutes: String, CaseIterable {
  case general
    
  var title: String {
    switch self {
    case .general:
      return "screen.settings.general"
    }
  }
}
