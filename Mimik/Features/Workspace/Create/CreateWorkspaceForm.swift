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
          )

          AppTextEditor(
            label: "Description",
            value: $viewModel.description,
            error: $viewModel.nameError,
            height: 100
          )

          
          //          Text("Description")
          //          TextEditor(text: $viewModel.description)
          //            .padding(.vertical, 4)
          //            .background(Color.white)
          //            .scrollContentBackground(.hidden)
          //            .frame(height: 100)
          //            .cornerRadius(6)
          //            .overlay(
          //              RoundedRectangle(cornerRadius: 6)
          //                .stroke(Color.gray.opacity(0.3))
          //            )
          
        }
        
        FilledButton(text: "Save", width: .infinity) {
          viewModel.saveWorkspace()
        }
        .padding(.top, 16)
      }
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
