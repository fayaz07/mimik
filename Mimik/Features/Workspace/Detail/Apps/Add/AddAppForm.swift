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

  private var platforms: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Platform")
        .font(.headline)

      HStack(spacing: 12) {
        ForEach(viewModel.getPlatforms(), id: \.self) { platform in
          PlatformOptionView(
            platform: platform,
            isSelected: viewModel.selectedPlatform == platform
          ) {
            viewModel.selectedPlatform = platform
            viewModel.clearSelectedPlatformError()
          }
        }
      }

      if let err = viewModel.selectedPlatformError, !err.isEmpty {
        Text(err)
          .foregroundColor(AppColors.danger)
          .font(.caption)
      }
    }
  }

  private var details: some View {
    VStack(alignment: .leading, spacing: 16) {
      AppTextField(
        label: "App Name",
        value: $viewModel.name,
        error: $viewModel.nameError
      )

      AppTextEditor(
        label: "App Description",
        value: $viewModel.description,
        error: $viewModel.descriptionError,
        height: 100
      )
    }
    .padding(16)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(AppColors.cardBorder, lineWidth: 1)
    )
  }

  private var saveButton: some View {
    Button(action: { viewModel.saveWorkspace(workspaceId: workspaceId) }) {
      HStack {
        Spacer()
        if viewModel.viewState.loading {
          ProgressView()
            .controlSize(.small)
            .tint(.white)
        } else {
          Text("Save")
        }
        Spacer()
      }
    }
    .buttonStyle(GradientPillButtonStyle())
    .disabled(viewModel.viewState.loading)
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        platforms
        details

        if let error = viewModel.viewState.error, !error.isEmpty {
          Text(error)
            .foregroundColor(AppColors.danger)
            .font(.caption)
        }

        saveButton
      }
      .padding(20)
    }
    .background(AppColors.canvasBackground)
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
