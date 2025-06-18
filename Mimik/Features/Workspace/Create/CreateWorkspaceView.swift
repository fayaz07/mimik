//
//  CreateWorkspace.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 10/06/25.
//

import SwiftUI

struct CreateWorkspaceView: View {
  @EnvironmentObject private var router: WorkspaceRouter
  
  var body: some View {
    VStack {
      
    }
    .padding(
      EdgeInsets.init(top: 8.0, leading: 8.0, bottom: 8.0, trailing: 8.0)
    )
    .navigationTitle("New Workspace")
    .toolbar {
      BackNavButton {
        router.navigateBack()
      }
    }
  }
}

#Preview {
  CreateWorkspaceView()
    .environmentObject(WorkspaceRouter())
}
