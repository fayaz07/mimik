//
//  WorkspaceSettingsScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI
import Factory

struct WorkspaceSettingsScreen: View {
  var data: WorkspaceEntity
  
  @EnvironmentObject var router: AppNavigationRouter
  @State private var viewModel: WorkspaceSettingsViewModel
  
  init(data: WorkspaceEntity) {
    self.data = data
    self._viewModel = State(
      wrappedValue: WorkspaceSettingsViewModel(
        workspaceRepository: Container.shared.workspaceRepository.resolve()
      )
    )
  }
  
  var body: some View {
    VStack {
      content
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.white)
    .navigationTitle("Settings - \(data.name)")
  }
  
  var content: some View {
    ZStack {
      deleteView()
      
      if viewModel.deleteState.hasError {
        Snackbar(text: viewModel.deleteState.error!, show: true)
      }
    }
    .padding(16)
  }
  
  func deleteView() -> some View {
    return VStack(alignment: .leading) {
      Text("Delete")
        .font(.title)
        .padding(.bottom, 8)
      
      HStack {
        VStack(alignment: .leading) {
          Text("Delete Workspace")
            .font(.title2)
          Text(
            "Once you delete a workspace, there is no going back. Please be certain."
          )
          .font(.body)
        }
        
        Spacer(minLength: 16)
        
        FilledButton(
          text: "Delete",
          loading: viewModel.deleteState.loading,
          bgColor: Color.red,
          onTap: onDeleteWorkspace
        )
      }
      .onChange(of: viewModel.events) { _, event in
          guard let eventData = event.data else { return }
          
          switch eventData {
          case .deleted:
              router.pop()
              
          case .deleteFailed(let message):
              // Show toast/snackbar maybe
              print("Deletion failed: \(message)")

          case .nameChanged:
              // Ignore or handle if needed
              break
          }
      }

      Spacer()
    }
  }
  
  private func onDeleteWorkspace() {
    viewModel.deleteWorkspace(id: data.id)
  }
}

#Preview {
  // 1. Create a mock in-memory Core Data container for the preview
  let container = NSPersistentContainer(
    name: "YourDataModelName"
  ) // Replace with your model name

  // 2. Get the mock context
  let viewContext = container.viewContext

  // 3. Create a valid instance of WorkspaceEntity within the context
  let workspace = WorkspaceEntity(context: viewContext)
  workspace.id = UUID()
  workspace.name = "Workspace 1"
  workspace.desc = "Workspace 1 Description"

  return VStack {
    WorkspaceSettingsScreen(data: workspace)
  }
}
