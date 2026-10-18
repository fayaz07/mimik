//
//  WorkspaceTranslationsScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI
import CoreData
import Factory

struct WSTranslationsScreen: View {
  var data: WorkspaceDTO

  @EnvironmentObject var router: AppNavigationRouter

  @Injected(\.trlsnScreenViewModel)
  var viewModel: WSTranslationsViewModel

  var body: some View {
    // No outer ScrollView here - TrslnGroupDetailView already wraps its own
    // content in one. Nesting ScrollViews on macOS can collapse the inner
    // one's height to zero, which looks exactly like a screen stuck on its
    // loading indicator even though the data underneath loaded fine.
    ViewStateUIBuilder(state: viewModel.groups) {
      ProgressView()
    } forError: { error in
      Text(error)
    } forData: { allGroups in
      return TrslnGroupDetailView(
        workspaceId: data.id,
        currentGroup: allGroups.0,
        parentGroups: [],
      )
    } forNoData: {
      Text("No groups, please add a group")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .onAppear {
      viewModel.fetchGroups(workspaceId: data.id)
    }
  }
}

#Preview {
  //  WorkspaceTranslationsScreen(id: UUID())
}
