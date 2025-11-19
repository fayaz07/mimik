//
//  AddAppForm.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

import SwiftUI

struct AddAppForm: View {
  @Bindable var viewModel: AddAppViewModel
  
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
//    AddAppForm()
}
