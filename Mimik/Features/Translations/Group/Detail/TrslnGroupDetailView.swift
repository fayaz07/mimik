//
//  TrslnGroupDetailView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 29/04/26.
//

import SwiftUI
import Factory
import Flow

struct TrslnGroupDetailView: View {

  let workspaceId: UUID
  let currentGroup: TranslationGroupDTO
  let parentGroups: [BreadcrumbItem]

  @EnvironmentObject var router: AppNavigationRouter

  @Injected(\.trslnGroupDetailViewModel)
  var viewModel: TrslnGroupDetailViewModel

  /// Driven by both the header's "+ Add Group"/"+ Add Key" buttons and the
  /// ghost cards themselves, so creating either happens inline on this
  /// screen instead of pushing to a separate Add screen.
  @State private var isAddingGroup = false
  @State private var isAddingKey = false

  private var breadcrumbTrailForChildren: [BreadcrumbItem] {
    parentGroups + [
      BreadcrumbItem(id: currentGroup.id.uuidString, label: currentGroup.displayLabel)
    ]
  }

  /// This screen's own route, as it would appear on the nav stack. Used to
  /// detect "we've been popped back to" so we can refresh - mirrors the
  /// .onChange(of: router.currentScreen) pattern HomeScreen already uses,
  /// since .onAppear alone isn't always enough to catch a return from a
  /// pushed Add Group / Add Key screen.
  private var ownRoute: Route {
    .workspace(
      .translations(
        .groupDetail(
          workspaceId: workspaceId,
          group: currentGroup,
          parentGroups: parentGroups
        )
      )
    )
  }

  private func reload() {
    viewModel.load(groupId: currentGroup.id, workspaceId: workspaceId)
  }

  func onAddGroup() {
    isAddingGroup = true
  }

  func onAddKey() {
    isAddingKey = true
  }

  func onGroupTap(_ group: TranslationGroupDTO) {
    router.push(
      to: .workspace(
        .translations(
          .groupDetail(
            workspaceId: workspaceId,
            group: group,
            parentGroups: breadcrumbTrailForChildren
          )
        )
      )
    )
  }

  func onEditKey(_ key: TranslationKeyDTO) {
    router.push(
      to: .workspace(
        .translations(
          .editKey(
            workspaceId: workspaceId,
            key: key,
            groupName: currentGroup.displayLabel,
            parentGroups: parentGroups
          )
        )
      )
    )
  }

  /// Jumping to an ancestor via the breadcrumb: every group below the
  /// workspace root was reached by exactly one push, so popping
  /// (number of items after the tapped one) lands precisely back on it -
  /// the root itself (parentGroups.isEmpty) was never pushed, which this
  /// formula also handles correctly (it just pops everything).
  func onBreadcrumbTap(id: String) {
    let fullTrail = breadcrumbTrailForChildren
    guard let tappedIndex = fullTrail.firstIndex(where: { $0.id == id }) else { return }
    let popCount = fullTrail.count - 1 - tappedIndex
    if popCount > 0 {
      router.pop(times: popCount)
    }
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        GroupBreadcrumb(
          group: currentGroup,
          parentGroups: parentGroups,
          onAddGroup: onAddGroup,
          onAddKey: onAddKey,
          onBreadcrumbTap: onBreadcrumbTap
        )

        sectionHeader("Groups", icon: "folder.fill", count: viewModel.childGroups.data?.count)
        groupsSection

        sectionHeader("Keys", icon: "character.book.closed.fill", count: viewModel.keys.data?.count)
        keysSection
      }
      .padding(.bottom, 24)
    }
    .background(AppColors.canvasBackground)
    .toolbar {
      // The embedded root screen (reached from the Translations tab, not a
      // push) already gets a back button from WorkspaceDetailScreen's own
      // toolbar - only add one here for genuinely nested, pushed groups.
      if !parentGroups.isEmpty {
        BackNavButton {
          router.pop()
        }
      }
    }
    .onAppear {
      reload()
    }
    .onChange(of: router.currentScreen) { _, newScreen in
      if newScreen == ownRoute {
        reload()
      }
    }
  }

  func sectionHeader(_ title: String, icon: String, count: Int?) -> some View {
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

  var groupsSection: some View {
    ViewStateUIBuilder(
      state: viewModel.childGroups) {
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
          AddGroupCardView(
            workspaceId: workspaceId,
            parentGroupId: currentGroup.id,
            isEditing: $isAddingGroup,
            onAdded: reload
          )
        }
        .padding(.horizontal, 16)
      } forNoData: {
        HFlow(spacing: 16) {
          AddGroupCardView(
            workspaceId: workspaceId,
            parentGroupId: currentGroup.id,
            isEditing: $isAddingGroup,
            onAdded: reload
          )
        }
        .padding(.horizontal, 16)
      }
  }

  var keysSection: some View {
    ViewStateUIBuilder(
      state: viewModel.keys) {
        ProgressView()
          .padding(.horizontal, 16)
      } forError: { error in
        Text(error)
          .foregroundColor(.red)
          .padding(.horizontal, 16)
      } forData: { items in
        VStack(spacing: 8) {
          if items.isEmpty {
            emptyKeysPlaceholder
          }
          ForEach(items) { item in
            TranslationKeyRowView(item: item, onEdit: onEditKey)
          }
          AddKeyRowView(
            workspaceId: workspaceId,
            groupId: currentGroup.id,
            isEditing: $isAddingKey,
            onAdded: reload
          )
        }
        .padding(.horizontal, 16)
      } forNoData: {
        VStack(spacing: 8) {
          emptyKeysPlaceholder
          AddKeyRowView(
            workspaceId: workspaceId,
            groupId: currentGroup.id,
            isEditing: $isAddingKey,
            onAdded: reload
          )
        }
        .padding(.horizontal, 16)
      }
  }

  var emptyKeysPlaceholder: some View {
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

#Preview {
  //  TrslnGroupDetailView()
}
