//
//  CreateWorkspace.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 10/06/25.
//

import SwiftUI
import Factory
import CoreData

struct CreateWorkspaceScreen: View {
  @EnvironmentObject private var router: AppNavigationRouter
  @State private var viewModel: CreateWorkspaceVM
  
  init() {
    self._viewModel = State(
      wrappedValue: CreateWorkspaceVM(workspaceRepository: Container.shared.workspaceRepository.resolve())
    )
  }
  
  var body: some View {
    VStack {
      CreateWorkspaceForm(viewModel: viewModel)
    }
    .background(.white)
    .navigationTitle("New Workspace")
    .toolbar {
      BackNavButton {
        router.pop()
      }
    }
  }
}

#Preview {
  CreateWorkspaceScreen()
}
