//
//  AppsView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI
import CoreData
import Flow
import Factory

struct WSAppsScreen: View {
  @EnvironmentObject private var router: AppNavigationRouter

  /// Scoped to this tab, not the app-wide router - see AppsNavigator for
  /// why: pushing "Add App" through the global router would replace the
  /// whole WorkspaceDetailScreen, including its sidebar.
  @State private var navigator = AppsNavigator()

  @Injected(\.workspaceAppsViewModel)
  private var viewModel: WSAppsViewModel

  var data: WorkspaceDTO

  var body: some View {
    Group {
      if let topRoute = navigator.path.last {
        WorkspaceAppsNavigationView(route: topRoute)
          .id(topRoute)
      } else {
        ScrollView {
          content
            .padding(16)
        }
        .background(.white)
      }
    }
    .navigationTitle("Apps - \(data.name)")
    .onAppear {
      viewModel.fetchWorkspaceApps(workspaceId: data.id)
    }
    .onChange(of: router.currentScreen) { _, newPath in
      if newPath == .home {
        viewModel.fetchWorkspaceApps(workspaceId: data.id)
      }
    }
    .onChange(of: navigator.currentScreen) { _, newScreen in
      if newScreen == nil {
        viewModel.fetchWorkspaceApps(workspaceId: data.id)
      }
    }
    .environment(navigator)
  }
  
  var content: some View {
    VStack {
      ViewStateUIBuilder(
        state: viewModel.apps,
        forLoading: {
          ProgressView()
        },
        forError: { error in
          Text("Error: \(error)")
        },
        forData: { items in
          return AppsListBuilder(items: items)
        },
        forNoData: {
          Text("No items found.")
        }
      ).padding(0)
    }
    .padding(8)
  }
   
  private func onAddApp() {
    navigator.push(to: .add(workspaceId: data.id))
  }
  
  private func onAppClicked(data: WSAppDTO) {
    navigator.push(to: .detail(app: data))
  }
  
  @ViewBuilder
  private func AppsListBuilder(items: [WSAppDTO]) -> some View {
    VStack(alignment: .leading) {
      if items.isEmpty {
        VStack(alignment: .center) {
          Text("No items found.")
            .padding(.top, 16)
            .padding(.bottom, 16)
          AddAppView(action: onAddApp)
        }
      } else {
        HStack {
          HFlow(alignment: .firstTextBaseline, spacing: 16) {
            ForEach(items, id: \.self) { item in
              AppView(data: item, onClick: onAppClicked)
            }
            AddAppView(action: onAddApp)
          }
          Spacer()
        }
      }
    }.padding(0)
  }
}

#Preview {
//  WorkspaceAppsScreen(
//    id: UUID()
//  )
}
