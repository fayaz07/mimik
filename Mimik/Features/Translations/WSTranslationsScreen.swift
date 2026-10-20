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

  /// Scoped to this tab, not the app-wide router - see TranslationsNavigator
  /// for why: pushing nested groups through the global router would replace
  /// the whole WorkspaceDetailScreen, including its sidebar.
  @State private var navigator = TranslationsNavigator()

  @Injected(\.trlsnScreenViewModel)
  var viewModel: WSTranslationsViewModel

  var body: some View {
    // Deliberately NOT a NavigationStack(path:). That combination - a
    // NavigationStack embedded in a NavigationSplitView's detail pane,
    // driven by an @Observable object's path - would not reliably push:
    // logging proved nav.push()/pop() genuinely mutated navigator.path
    // (0 -> 5 across five taps), both with plain @State and with
    // @Bindable, but NavigationStack never rendered the new screen either
    // way. Rather than fight that further, this reads navigator.path
    // directly (a plain property read, the same proven-reliable mechanism
    // TrslnGroupDetailView already uses for nav.currentScreen) and swaps
    // content manually: whatever's on top of the local stack, or the root
    // group if the stack is empty. No NavigationStack involved, so nothing
    // to go stale - and the sidebar still stays visible either way, since
    // this is just conditional content inside the Translations tab, not a
    // push on the app-wide router.
    Group {
      if let topRoute = navigator.path.last {
        WorkspaceTranslationsNavigationView(route: topRoute)
          .id(topRoute)
      } else {
        // No outer ScrollView here - TrslnGroupDetailView already wraps
        // its own content in one. Nesting ScrollViews on macOS can
        // collapse the inner one's height to zero, which looks exactly
        // like a screen stuck on its loading indicator even though the
        // data underneath loaded.
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
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .transition(.asymmetric(
      insertion: .move(edge: .trailing).combined(with: .opacity),
      removal: .move(edge: .leading).combined(with: .opacity)
    ))
    .animation(.easeInOut(duration: 0.25), value: navigator.path.count)
    .onAppear {
      viewModel.fetchGroups(workspaceId: data.id)
    }
    .environment(navigator)
  }
}

#Preview {
  //  WorkspaceTranslationsScreen(id: UUID())
}
