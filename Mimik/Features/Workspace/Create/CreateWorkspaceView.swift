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
      Text("Hello, CreateWorkspaceView!")
    }
    .navigationTitle("Add New Workspace")
    .toolbar {
      ToolbarItem(placement: .navigation) {
        Button(action: {
          router.navigateBack()
        }) {
          Image(systemName: "chevron.left")
            .font(.system(size: 16, weight: .medium))
        }
      }
    }
  }
}

#Preview {
  CreateWorkspaceView()
}
