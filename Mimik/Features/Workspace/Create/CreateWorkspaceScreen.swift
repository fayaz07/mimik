//
//  CreateWorkspace.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 10/06/25.
//

import SwiftUI
import Factory

struct CreateWorkspaceScreen: View {
  @EnvironmentObject private var router: AppNavigationRouter
  @State private var viewModel: CreateWorkspaceVM
  
  init() {
    self._viewModel = State(
      wrappedValue: CreateWorkspaceVM(
        workspaceRepository: Container.shared.workspaceRepository.resolve()
      )
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
    .onChange(of: viewModel.viewEvents) { _, newEvent in
      guard let eventData = newEvent.data else { return }
      
      switch eventData {
        case .created(let id):
          router.push(to: .workspace(.detail(id: id)), replace: true)
      }
    }
  }
}

#Preview {
  CreateWorkspaceScreen()
}
