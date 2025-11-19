//
//  AppsView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI
import CoreData

struct WorkspaceAppsScreen: View {
  var data: WorkspaceEntity
  
  var body: some View {
    VStack {
      content
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.white)
    .navigationTitle("Apps - \(data.name)")
  }
  
  var content: some View {
    VStack {
      
    }
    .padding(8)
  }
}

#Preview {
//  WorkspaceAppsScreen(
//    id: UUID()
//  )
}
