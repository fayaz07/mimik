//
//  WorkspaceTranslationsScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI
import CoreData

struct WSTranslationsScreen: View {
  var data: WorkspaceDTO
  
  var body: some View {
    Text("Translations Screen, for \(data.name)")
  }
}

#Preview {
//  WorkspaceTranslationsScreen(id: UUID())
}
