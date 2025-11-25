//
//  AppsView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI
import CoreData

struct WorkspaceAppsScreen: View {
  @EnvironmentObject private var router: AppNavigationRouter
  
  var data: WorkspaceDTO
  
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
      Button("Add App") {
        router.push(to: .workspace(.apps(.add(workspaceId: data.id))))
      }
    }
    .padding(8)
  }
}

#Preview {
//  WorkspaceAppsScreen(
//    id: UUID()
//  )
}
