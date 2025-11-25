//
//  AddAppForm.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

import SwiftUI
import Factory

struct AddAppForm: View {
  var workspaceId: UUID

  @Bindable var viewModel: AddAppViewModel
  
  var platforms: some View {
    Section {
      HStack {
        VStack(alignment: .leading) {
          Text(
            "Select Platform"
          ).padding(.leading, 8)
          Picker("", selection: $viewModel.selectedPlatform) {
            ForEach(viewModel.getPlatforms(), id: \.self) { platform in
              Text(platform.name)
                .foregroundStyle(.black)
                .lineLimit(1)
                .tag(Optional(platform))
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .contentShape(Rectangle())
          .pickerStyle(.menu)
          .onChange(of: viewModel.selectedPlatform) {
            viewModel.clearSelectedPlatformError()
          }
          
          if let err = viewModel.selectedPlatformError, !err.isEmpty {
            Text(err)
              .foregroundColor(.red)
              .font(.caption)
              .padding(.leading, 16)
          }
        }
        
        Spacer()
        
        if viewModel.selectedPlatform != nil {
          Image(viewModel.selectedPlatform!.icon)
            .resizable()
            .scaledToFit()
            .frame(width: 48, height: 48)
        }
      }
    }.padding(.bottom, 8)
  }
  
  var body: some View {
    VStack {
      Form {
        platforms
        
        Section {
          AppTextField(
            label: "App Name",
            value: $viewModel.name,
            error: $viewModel.nameError
          ).padding(.bottom, 8)
          
          AppTextEditor(
            label: "App Description",
            value: $viewModel.description,
            error: $viewModel.descriptionError,
            height: 100
          )
        }
        
        FilledButton(text: "Save", width: .infinity) {
          viewModel.saveWorkspace(workspaceId: workspaceId)
        }
        .padding(.top, 16)
      }
      Spacer()
    }
    .padding()
  }
}

#Preview {
  @Injected(\.addAppViewModel)
  var viewModel: AddAppViewModel
  
  AddAppForm(
    workspaceId: UUID(),
    viewModel: viewModel
  )
}
