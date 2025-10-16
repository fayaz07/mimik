//
//  WorkspaceDashboardScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI
import CoreData

struct WorkspaceDashboardScreen: View {
  var data: WorkspaceEntity
  
  var body: some View {
    VStack {
      content
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.white)
    .navigationTitle(data.name)
  }
  
  var content: some View {
    VStack {
      Text("Workspace Dashboard")
    }
    .padding(8)
  }
}

#Preview {
  //  WorkspaceDashboardScreen(
  //    id: UUID()
  //  )
}
