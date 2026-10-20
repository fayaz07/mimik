//
//  AddGroupCardView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import SwiftUI
import Factory

/// Normally a dashed "ghost" card; tapping it (or driving `isEditing` true
/// from the header's "+ Add Group" button) morphs it in place into a small
/// inline form, so creating a group never leaves this screen. Talks to the
/// create usecase directly rather than a long-lived ViewModel, since this
/// card's own @State (name/error/submitting) is all it needs to hold onto.
struct AddGroupCardView: View {
  let workspaceId: UUID
  let parentGroupId: UUID
  @Binding var isEditing: Bool
  var onAdded: () -> Void = {}

  @State private var name = ""
  @State private var isSubmitting = false
  @State private var errorMessage: String?
  @State private var isHovered = false
  @FocusState private var isFocused: Bool

  @Injected(\.createTrslnUsecase) private var createUsecase: CreateTranslationUsecase

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
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .strokeBorder(
            isHovered ? AppColors.primaryStart.opacity(0.6) : Color.gray.opacity(0.3),
            style: StrokeStyle(lineWidth: 1.5, dash: [6, 5])
          )
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(isHovered ? AppColors.primaryStart.opacity(0.05) : Color.clear)
          )

        content
      }
    }
    .buttonStyle(PlainButtonStyle())
    .frame(width: 200, height: 128)
    .animation(.easeOut(duration: 0.15), value: isHovered)
    .onHover { isHovered = $0 }
  }

  var content: some View {
    VStack(spacing: 8) {
      ZStack {
        Circle()
          .fill(AppColors.primaryStart.opacity(0.1))
          .frame(width: 36, height: 36)

        Image(systemName: "plus")
          .font(.system(size: 15, weight: .bold))
          .foregroundStyle(AppColors.primaryStart)
      }

      Text("Add Group")
        .font(.subheadline.weight(.medium))
        .foregroundStyle(AppColors.primaryStart)
    }
    .padding(16)
    .multilineTextAlignment(.center)
  }

  private var editingContent: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("New Group")
        .font(.caption.weight(.semibold))
        .foregroundColor(.secondary)

      TextField("Group name", text: $name)
        .textFieldStyle(.roundedBorder)
        .focused($isFocused)
        .disabled(isSubmitting)
        .onSubmit { submit() }

      if let errorMessage {
        Text(errorMessage)
          .font(.caption2)
          .foregroundColor(AppColors.danger)
          .fixedSize(horizontal: false, vertical: true)
      }

      HStack {
        Spacer()

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
    }
    .padding(14)
    .frame(width: 200)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(.white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(AppColors.primaryStart.opacity(0.4), lineWidth: 1.5)
    )
    .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    .onAppear { isFocused = true }
  }

  private func submit() {
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      errorMessage = "Group name cannot be empty"
      return
    }
    isSubmitting = true
    errorMessage = nil
    Task {
      do {
        _ = try await createUsecase.create(
          workspaceId: workspaceId,
          key: trimmed,
          parentGroupId: parentGroupId
        )
        await MainActor.run {
          isSubmitting = false
          name = ""
          isEditing = false
          onAdded()
        }
      } catch {
        var errString = "Failed to add group"
        if let validationError = error as? ValidationError {
          switch validationError {
            case .EmptyKey:
              errString = "Group name cannot be empty"
            case .AlreadyExists:
              errString = "A group with this name already exists"
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
    errorMessage = nil
    isEditing = false
  }
}

#Preview {
  AddGroupCardView(
    workspaceId: UUID(),
    parentGroupId: UUID(),
    isEditing: .constant(false)
  )
  .padding()
  .background(AppColors.canvasBackground)
}
