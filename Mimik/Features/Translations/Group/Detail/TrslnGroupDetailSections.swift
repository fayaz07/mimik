//
//  TrslnGroupDetailSections.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/10/26.
//
//  The Groups/Keys section UI pulled out of TrslnGroupDetailView so that file
//  can stay focused on navigation + composition, with the actual section
//  rendering logic (and its own small bits of @State-free presentation)
//  living here instead.

import SwiftUI
import Flow

/// A small section title row shared by the Groups and Keys sections -
/// icon, title, and an optional pill showing the item count.
struct SectionHeaderView: View {
  let title: String
  let icon: String
  let count: Int?

  var body: some View {
    HStack(spacing: 8) {
      Image(systemName: icon)
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(AppColors.primaryStart)

      Text(title)
        .font(.headline)

      if let count {
        Text("\(count)")
          .font(.caption.weight(.bold))
          .foregroundColor(AppColors.primaryStart)
          .padding(.horizontal, 8)
          .padding(.vertical, 2)
          .background(
            Capsule().fill(AppColors.primaryStart.opacity(0.12))
          )
      }
    }
    .padding(.horizontal, 16)
    .padding(.top, 12)
    .padding(.bottom, 8)
  }
}

/// Renders the current group's child groups as a wrapping grid of folder
/// cards, plus the inline "+ Add Group" ghost card.
struct GroupsSectionView: View {
  let state: ViewState<[TranslationGroupDTO]>
  let workspaceId: UUID
  let parentGroupId: UUID
  @Binding var isAddingGroup: Bool
  let onAdded: () -> Void
  let onGroupTap: (TranslationGroupDTO) -> Void

  var body: some View {
    ViewStateUIBuilder(
      state: state) {
        ProgressView()
          .padding(.horizontal, 16)
      } forError: { error in
        Text(error)
          .foregroundColor(.red)
          .padding(.horizontal, 16)
      } forData: { groups in
        HFlow(alignment: .top, spacing: 16) {
          ForEach(groups) { group in
            GroupFolderCardView(group: group, onClick: onGroupTap)
          }
          addGroupCard
        }
        .padding(.horizontal, 16)
      } forNoData: {
        HFlow(spacing: 16) {
          addGroupCard
        }
        .padding(.horizontal, 16)
      }
  }

  private var addGroupCard: some View {
    AddGroupCardView(
      workspaceId: workspaceId,
      parentGroupId: parentGroupId,
      isEditing: $isAddingGroup,
      onAdded: onAdded
    )
  }
}

/// Renders the current group's keys as a list of rows, plus the inline
/// "+ Add Key" ghost row. Shows a placeholder above the add row when there
/// are no keys yet.
struct KeysSectionView: View {
  let state: ViewState<[KeyListItem]>
  let workspaceId: UUID
  let groupId: UUID
  @Binding var isAddingKey: Bool
  let onAdded: () -> Void
  let onEditKey: (TranslationKeyDTO) -> Void

  var body: some View {
    ViewStateUIBuilder(
      state: state) {
        ProgressView()
          .padding(.horizontal, 16)
      } forError: { error in
        Text(error)
          .foregroundColor(.red)
          .padding(.horizontal, 16)
      } forData: { items in
        VStack(spacing: 8) {
          if items.isEmpty {
            EmptyKeysPlaceholder()
          }
          ForEach(items) { item in
            TranslationKeyRowView(item: item, onEdit: onEditKey)
          }
          addKeyRow
        }
        .padding(.horizontal, 16)
      } forNoData: {
        VStack(spacing: 8) {
          EmptyKeysPlaceholder()
          addKeyRow
        }
        .padding(.horizontal, 16)
      }
  }

  private var addKeyRow: some View {
    AddKeyRowView(
      workspaceId: workspaceId,
      groupId: groupId,
      isEditing: $isAddingKey,
      onAdded: onAdded
    )
  }
}

struct EmptyKeysPlaceholder: View {
  var body: some View {
    VStack(spacing: 4) {
      Image(systemName: "character.book.closed")
        .font(.system(size: 26))
        .foregroundStyle(Color.gray.opacity(0.35))

      Text("No keys yet")
        .font(.subheadline.weight(.medium))
        .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 20)
  }
}
