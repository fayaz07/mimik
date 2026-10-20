//
//  AddKeyRowView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 18/10/26.
//

import SwiftUI
import Factory

/// AddKeyRowView - the row-shaped sibling of AddGroupCardView. Idle, it's a
/// dashed "+ Add Key" row at the bottom of the keys list; tapping it (or
/// driving `isEditing` true from the header's "+ Add Key" button) expands it
/// in place into a name field + Save/Cancel, so adding a key never leaves
/// this screen.
struct AddKeyRowView: View {
  let workspaceId: UUID
  let groupId: UUID
  var allApps: [WSAppDTO] = []
  @Binding var isEditing: Bool
  var onAdded: () -> Void = {}

  @State private var name = ""
  @State private var excludedAppIds: Set<UUID> = []
  @State private var isSubmitting = false
  @State private var errorMessage: String?
  @State private var isHovered = false
  @FocusState private var isFocused: Bool

  @Injected(\.createTrslnKeyUsecase) private var createUsecase: CreateTranslationKeyUsecase

  var body: some View {
    Group {
      if isEditing {
        editingContent
      } else {
        ghostContent
      }
    }
    .animation(.easeOut(duration: 0.15), value: isEditing)
  }

  private var ghostContent: some View {
    Button(action: { isEditing = true }) {
      HStack(spacing: 10) {
        Image(systemName: "plus.circle.fill")
          .font(.system(size: 14))
          .foregroundStyle(AppColors.primaryStart)

        Text("Add Key")
          .font(.subheadline.weight(.medium))
          .foregroundStyle(AppColors.primaryStart)

        Spacer()
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 14)
      .background(
        RoundedRectangle(cornerRadius: 12)
          .strokeBorder(
            isHovered ? AppColors.primaryStart.opacity(0.6) : Color.gray.opacity(0.3),
            style: StrokeStyle(lineWidth: 1.5, dash: [6, 5])
          )
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(isHovered ? AppColors.primaryStart.opacity(0.05) : Color.clear)
          )
      )
    }
    .buttonStyle(PlainButtonStyle())
    .animation(.easeOut(duration: 0.15), value: isHovered)
    .onHover { isHovered = $0 }
  }

  private var editingContent: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 10) {
        TextField("Key name", text: $name)
          .textFieldStyle(.roundedBorder)
          .focused($isFocused)
          .disabled(isSubmitting)
          .onSubmit { submit() }

        Button("Cancel") { cancel() }
          .buttonStyle(GhostButtonStyle(color: .secondary))
          .disabled(isSubmitting)

        Button(action: submit) {
          if isSubmitting {
            ProgressView()
              .controlSize(.small)
          } else {
            Text("Add")
          }
        }
        .buttonStyle(GradientPillButtonStyle())
        .disabled(isSubmitting)
        .keyboardShortcut(.defaultAction)
      }

      if !allApps.isEmpty {
        VStack(alignment: .leading, spacing: 4) {
          Text("Included in")
            .font(.caption2.weight(.semibold))
            .foregroundColor(.secondary)

          AppInclusionPicker(
            apps: allApps,
            excludedAppIds: excludedAppIds,
            isDisabled: isSubmitting
          ) { app in
            if excludedAppIds.contains(app.id) {
              excludedAppIds.remove(app.id)
            } else {
              excludedAppIds.insert(app.id)
            }
          }
        }
      }

      if let errorMessage {
        Text(errorMessage)
          .font(.caption2)
          .foregroundColor(AppColors.danger)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .padding(12)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(.white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(AppColors.primaryStart.opacity(0.4), lineWidth: 1.5)
    )
    .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
    .onAppear { isFocused = true }
  }

  private func submit() {
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      errorMessage = "Key name cannot be empty"
      return
    }
    isSubmitting = true
    errorMessage = nil
    Task {
      do {
        _ = try await createUsecase.create(
          workspaceId: workspaceId,
          groupId: groupId,
          key: trimmed,
          excludedApps: Array(excludedAppIds)
        )
        await MainActor.run {
          isSubmitting = false
          name = ""
          excludedAppIds = []
          isEditing = false
          onAdded()
        }
      } catch {
        var errString = "Failed to add key"
        if let validationError = error as? ValidationError {
          switch validationError {
            case .EmptyKey:
              errString = "Key name cannot be empty"
            case .AlreadyExists:
              errString = "A key with this name already exists in this group"
          }
        }
        await MainActor.run {
          isSubmitting = false
          errorMessage = errString
        }
      }
    }
  }

  private func cancel() {
    name = ""
    excludedAppIds = []
    errorMessage = nil
    isEditing = false
  }
}

#Preview {
  VStack(spacing: 8) {
    AddKeyRowView(
      workspaceId: UUID(),
      groupId: UUID(),
      isEditing: .constant(false)
    )

    AddKeyRowView(
      workspaceId: UUID(),
      groupId: UUID(),
      isEditing: .constant(true)
    )
  }
  .padding()
  .background(AppColors.canvasBackground)
}
