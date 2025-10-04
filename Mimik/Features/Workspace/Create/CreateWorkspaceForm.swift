//
//  CreateWorkspaceForm.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/08/25.
//

import SwiftUI

struct CreateWorkspaceForm: View {
  @Bindable var viewModel: CreateWorkspaceVM
  
  var body: some View {
    VStack {
      Form {
        Section {
          AppTextField(
            label: "Name",
            value: $viewModel.name,
            error: $viewModel.nameError
          ).padding(.bottom, 8)
          
          AppTextEditor(
            label: "Description",
            value: $viewModel.description,
            error: $viewModel.descriptionError,
            height: 100
          )
        }
        
        FilledButton(text: "Save", width: .infinity) {
          viewModel.saveWorkspace()
        }
        .padding(.top, 16)
      }
      Spacer()
    }
    .padding()
  }
}

#Preview {
  CreateWorkspaceForm(
    viewModel: CreateWorkspaceVM(
      workspaceRepository: WorkspaceRepositoryImpl(
        localSource: WorkspaceLocalDataSource(context: NSManagedObjectContext())
      )
    )
  )
}
