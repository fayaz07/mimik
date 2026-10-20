//
//  AddAppScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

import SwiftUI
import Factory

struct AddAppScreen: View {
  var workspaceId: UUID

  /// Local to the Apps tab, not the app-wide router - see AppsNavigator for
  /// why (keeps the workspace sidebar visible instead of this screen
  /// replacing the whole WorkspaceDetailScreen).
  @Environment(AppsNavigator.self) var nav: AppsNavigator

  @Injected(\.addAppViewModel)
  private var viewModel: AddAppViewModel

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Inline, not .toolbar - this screen is no longer pushed onto its own
      // NavigationStack (see WSAppsScreen for why), and a .toolbar here
      // would bubble up to whichever ancestor actually hosts one, which
      // could collide with WorkspaceDetailScreen's own always-on back
      // button. Plain content avoids that ambiguity.
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
      .padding(.bottom, 8)

      AddAppForm(
        workspaceId: workspaceId,
        viewModel: viewModel
      )
    }
    .background(.white)
    .navigationTitle("Add App")
    .onChange(of: viewModel.viewEvents) { _, newEvent in
      guard newEvent.data != nil else { return }
      nav.pop()
    }
  }
}
