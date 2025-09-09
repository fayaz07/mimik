//
//  CreateWorkspace.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 10/06/25.
//

import SwiftUI
import Factory
import CoreData

struct CreateWorkspaceView: View {
  @EnvironmentObject private var router: WorkspaceRouter
  //  @State var viewModel: CreateWorkspaceVM = CreateWorkspaceVM()
 
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
