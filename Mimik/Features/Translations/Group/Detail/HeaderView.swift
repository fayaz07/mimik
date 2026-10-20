//
//  HeaderView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 03/09/26.
//
import SwiftUI
import Factory

struct GroupBreadcrumb : View {

  let workspaceId: UUID
  let group: TranslationGroupDTO
  let parentGroups: [BreadcrumbItem]
  var onAddGroup: () -> Void = {}
  var onAddKey: () -> Void = {}
  var onBreadcrumbTap: (String) -> Void = { _ in }
  var onRenamed: (TranslationGroupDTO) -> Void = { _ in }
  var onDeleted: () -> Void = {}

  @State private var isRenaming = false
  @State private var renameText = ""
  @State private var isSubmittingRename = false
  @State private var renameError: String?
  @FocusState private var isRenameFocused: Bool

  @State private var isConfirmingDelete = false
  @State private var isDeleting = false
  @State private var deleteError: String?

  @Injected(\.renameTrslnGroupUsecase) private var renameUsecase: RenameTranslationGroupUsecase
  @Injected(\.deleteTrslnGroupUsecase) private var deleteUsecase: DeleteTranslationGroupUsecase

  var body: some View {
    HStack(alignment: .top) {
      headerLeftSection()
      Spacer()
      headerRightSection()
    }
    .padding(.all, 20)
    .background(
      Rectangle()
        .fill(.white)
        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
    )
    .confirmationDialog(
      "Delete \"\(group.displayLabel)\"?",
      isPresented: $isConfirmingDelete,
      titleVisibility: .visible
    ) {
      Button("Delete", role: .destructive) { delete() }
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("This also deletes every subgroup and key inside it. This can't be undone.")
    }
    .alert(
      "Couldn't delete this group",
      isPresented: Binding(
        get: { deleteError != nil },
        set: { if !$0 { deleteError = nil } }
      )
    ) {
      Button("OK", role: .cancel) {}
    } message: {
      Text(deleteError ?? "Something went wrong. Please try again.")
    }
  }

  func headerRightSection() -> some View {
    return HStack(spacing: 10) {
      // Rename/Delete act on the current group itself, so they only make
      // sense for nested groups - the workspace's root group isn't a real,
      // user-created group and can't be renamed or deleted.
      if !parentGroups.isEmpty && !isRenaming {
        Button(action: startRenaming) {
          Label("Rename", systemImage: "pencil")
        }
        .buttonStyle(GhostButtonStyle(color: .black.opacity(0.65)))
        .disabled(isDeleting)

        Button(action: { isConfirmingDelete = true }) {
          if isDeleting {
            ProgressView()
              .controlSize(.small)
          } else {
            Label("Delete", systemImage: "trash")
          }
        }
        .buttonStyle(GhostButtonStyle(color: AppColors.danger))
        .disabled(isDeleting)
      }

      Button(action: onAddGroup) {
        Label("Add Group", systemImage: "folder.badge.plus")
      }
      .buttonStyle(GradientPillButtonStyle())

      Button(action: onAddKey) {
        Label("Add Key", systemImage: "plus.circle.fill")
      }
      .buttonStyle(GradientPillButtonStyle())
    }
  }

  func headerLeftSection() -> some View {
    VStack(alignment: .leading, spacing: 6) {
      if isRenaming {
        renameField
      } else {
        Text(group.displayLabel)
          .font(.title2)
          .bold()
      }

      Breadcrumb(
        items: parentGroups + [
          BreadcrumbItem(
            id: group.id.uuidString,
            label: group.displayLabel
          )
        ],
        onTap: onBreadcrumbTap
      )
    }
  }

  private var renameField: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(spacing: 8) {
        TextField("Group name", text: $renameText)
          .textFieldStyle(.roundedBorder)
          .font(.title3)
          .frame(maxWidth: 260)
          .focused($isRenameFocused)
          .disabled(isSubmittingRename)
          .onSubmit { submitRename() }

        if isSubmittingRename {
          ProgressView()
            .controlSize(.small)
        } else {
          Button(action: submitRename) {
            Image(systemName: "checkmark.circle.fill")
          }
          .buttonStyle(.plain)
          .foregroundStyle(AppColors.primaryStart)

          Button(action: cancelRenaming) {
            Image(systemName: "xmark.circle.fill")
          }
          .buttonStyle(.plain)
          .foregroundStyle(.secondary)
        }
      }

      if let renameError {
        Text(renameError)
          .font(.caption2)
          .foregroundColor(AppColors.danger)
      }
    }
    .onAppear { isRenameFocused = true }
  }

  private func startRenaming() {
    renameText = group.displayLabel
    renameError = nil
    isRenaming = true
  }

  private func cancelRenaming() {
    isRenaming = false
    renameError = nil
  }

  private func submitRename() {
    let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else {
      renameError = "Group name cannot be empty"
      return
    }
    guard trimmed != group.displayLabel else {
      isRenaming = false
      return
    }
    isSubmittingRename = true
    renameError = nil
    Task {
      do {
        let updated = try await renameUsecase.rename(
          workspaceId: workspaceId,
          groupId: group.id,
          parentGroupId: group.parentGroupId,
          name: trimmed
        )
        await MainActor.run {
          isSubmittingRename = false
          isRenaming = false
          onRenamed(updated)
        }
      } catch {
        var errString = "Failed to rename group"
        if let validationError = error as? ValidationError {
          switch validationError {
            case .EmptyKey:
              errString = "Group name cannot be empty"
            case .AlreadyExists:
              errString = "A group with this name already exists"
          }
        }
        await MainActor.run {
          isSubmittingRename = false
          renameError = errString
        }
      }
    }
  }

  private func delete() {
    isDeleting = true
    Task {
      do {
        try await deleteUsecase.delete(groupId: group.id, workspaceId: workspaceId)
        await MainActor.run {
          isDeleting = false
          onDeleted()
        }
      } catch {
        await MainActor.run {
          isDeleting = false
          deleteError = "Something went wrong. Please try again."
        }
      }
    }
  }
}

#Preview {
  GroupBreadcrumb(
    workspaceId: UUID(),
    group: TranslationGroupDTO(
      id: UUID(),
      workspaceId: UUID(),
      key: "general-group",
      parentGroupId: nil,
      createdAt: Date(),
      updatedAt: Date()
    ),
    parentGroups: [
      BreadcrumbItem(id: "home-id", label: "Home", icon: "house"),
      //      BreadcrumbItem(id: "locales-id", label: "Locales", icon: "globe"),
      //      BreadcrumbItem(id: "auth-id", label: "Authentication", icon: "folder")
    ]
  )
}
