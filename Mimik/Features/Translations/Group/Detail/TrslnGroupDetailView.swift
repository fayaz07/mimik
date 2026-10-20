//
//  TrslnGroupDetailView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 29/04/26.
//

import SwiftUI
import Factory

struct TrslnGroupDetailView: View {

  let workspaceId: UUID
  let parentGroups: [BreadcrumbItem]

  /// Held in @State, not `let` - a successful rename updates this in place
  /// so the breadcrumb/title reflect the new name immediately, without
  /// needing a full reload. The id never changes, only key/updatedAt.
  @State private var currentGroup: TranslationGroupDTO

  /// Local to the Translations tab, not the app-wide router - see
  /// TranslationsNavigator for why (keeps the workspace sidebar visible
  /// while drilling into nested groups).
  @Environment(TranslationsNavigator.self) var nav: TranslationsNavigator

  /// Resolved once, in init, and held in @State rather than @Injected.
  /// @Injected's default (uncached) Factory scope re-resolves a BRAND NEW
  /// instance every time this struct is reconstructed - which happens
  /// whenever a view reading @Environment(TranslationsNavigator.self)
  /// re-renders, including right after nav.push() mutates the shared
  /// navigator. That re-render was orphaning the in-flight load() Task on
  /// the old instance and leaving the view holding a fresh, never-loaded
  /// one - permanently stuck on the loading spinner for nested groups.
  /// @State (like WorkspaceDetailScreen's own viewModel) preserves the same
  /// instance across re-renders for as long as this screen's identity
  /// lives, which is exactly what we need here. Not .scope(.singleton):
  /// root and nested group screens are simultaneously alive on the nav
  /// stack and must not share one ViewModel's state.
  @State private var viewModel: TrslnGroupDetailViewModel

  /// Driven by both the header's "+ Add Group"/"+ Add Key" buttons and the
  /// ghost cards themselves, so creating either happens inline on this
  /// screen instead of pushing to a separate Add screen.
  @State private var isAddingGroup = false
  @State private var isAddingKey = false

  /// Scopes the Keys section to one app at a time, driven by the picker in
  /// GroupBreadcrumb. nil shows every key regardless of which apps it's
  /// excluded from.
  @State private var selectedAppFilter: WSAppDTO?

  init(workspaceId: UUID, currentGroup: TranslationGroupDTO, parentGroups: [BreadcrumbItem]) {
    self.workspaceId = workspaceId
    self._currentGroup = State(wrappedValue: currentGroup)
    self.parentGroups = parentGroups
    self._viewModel = State(wrappedValue: Container.shared.trslnGroupDetailViewModel.resolve())
  }

  private var breadcrumbTrailForChildren: [BreadcrumbItem] {
    parentGroups + [
      BreadcrumbItem(id: currentGroup.id.uuidString, label: currentGroup.displayLabel)
    ]
  }

  /// This screen's own route, as it would appear on the local nav stack.
  /// Used to detect "we've been popped back to" so we can refresh - mirrors
  /// the .onChange(of: router.currentScreen) pattern HomeScreen uses for
  /// the app-wide router, just scoped to this tab's own navigator.
  private var ownRoute: Route.WorkspaceRoute.TranslationsRoute {
    .groupDetail(
      workspaceId: workspaceId,
      group: currentGroup,
      parentGroups: parentGroups
    )
  }

  private func reload() {
    viewModel.load(groupId: currentGroup.id, workspaceId: workspaceId)
  }

  /// Count for the Keys section header - reflects the app filter, so it
  /// doesn't show a total that disagrees with what's actually listed below.
  private var filteredKeyCount: Int? {
    viewModel.keys.data?.filter { $0.isIncluded(in: selectedAppFilter) }.count
  }

  func onAddGroup() {
    isAddingGroup = true
  }

  func onAddKey() {
    isAddingKey = true
  }

  func onGroupRenamed(_ updated: TranslationGroupDTO) {
    currentGroup = updated
  }

  /// The currently-open group deleted itself - there's nothing left to show
  /// here, so leave for wherever it was reached from. The parent screen
  /// remounts fresh when we land back on it (see WSTranslationsScreen's
  /// .id(topRoute)), which re-fetches its own child groups and naturally
  /// drops the one we just deleted.
  func onGroupDeleted() {
    nav.pop()
  }

  func onGroupTap(_ group: TranslationGroupDTO) {
    nav.push(
      to: .groupDetail(
        workspaceId: workspaceId,
        group: group,
        parentGroups: breadcrumbTrailForChildren
      )
    )
  }

  func onEditKey(_ key: TranslationKeyDTO) {
    nav.push(
      to: .editKey(
        workspaceId: workspaceId,
        key: key,
        groupName: currentGroup.displayLabel,
        parentGroups: parentGroups
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
      nav.pop(times: popCount)
    }
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {
        // Inline, not .toolbar - this screen is no longer pushed onto its
        // own NavigationStack (see WSTranslationsScreen for why), and a
        // .toolbar here would bubble up to whichever ancestor actually
        // hosts one, which could collide with WorkspaceDetailScreen's own
        // always-on back button. Plain content avoids that ambiguity.
        // The embedded root screen (reached from the Translations tab, not
        // a push) doesn't need this - WorkspaceDetailScreen's own back
        // button already leaves the whole workspace from there.
        if !parentGroups.isEmpty {
          Button(action: { nav.pop() }) {
            HStack(spacing: 4) {
              Image(systemName: "chevron.left")
              Text("Back")
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(AppColors.primaryStart)
          }
          .buttonStyle(.plain)
          .padding(.horizontal, 16)
          .padding(.top, 12)
          .padding(.bottom, 4)
        }

        GroupBreadcrumb(
          workspaceId: workspaceId,
          group: currentGroup,
          parentGroups: parentGroups,
          onAddGroup: onAddGroup,
          onAddKey: onAddKey,
          onBreadcrumbTap: onBreadcrumbTap,
          onRenamed: onGroupRenamed,
          onDeleted: onGroupDeleted,
          allApps: viewModel.workspaceApps.data ?? [],
          selectedApp: selectedAppFilter,
          onSelectApp: { selectedAppFilter = $0 }
        )

        SectionHeaderView(title: "Groups", icon: "folder.fill", count: viewModel.childGroups.data?.count)
        GroupsSectionView(
          state: viewModel.childGroups,
          workspaceId: workspaceId,
          parentGroupId: currentGroup.id,
          isAddingGroup: $isAddingGroup,
          onAdded: reload,
          onGroupTap: onGroupTap
        )

        SectionHeaderView(title: "Keys", icon: "character.book.closed.fill", count: filteredKeyCount)
        KeysSectionView(
          state: viewModel.keys,
          workspaceId: workspaceId,
          groupId: currentGroup.id,
          allApps: viewModel.workspaceApps.data ?? [],
          selectedAppFilter: selectedAppFilter,
          isAddingKey: $isAddingKey,
          onAdded: reload,
          onEditKey: onEditKey
        )
      }
      .padding(.bottom, 24)
    }
    .background(AppColors.canvasBackground)
    .onAppear {
      reload()
    }
    .onChange(of: nav.currentScreen) { _, newScreen in
      if newScreen == ownRoute {
        reload()
      }
    }
  }
}

#Preview {
  //  TrslnGroupDetailView()
}
