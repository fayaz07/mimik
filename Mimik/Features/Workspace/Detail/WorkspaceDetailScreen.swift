//
//  WorkspaceDetailScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 08/10/25.
//

import SwiftUI
import CoreData
import Factory

struct WorkspaceDetailScreen: View {
  var id: UUID
  
  @EnvironmentObject var router: AppNavigationRouter
  @State private var selectedTab: WorkspaceDetailRoute = .dashboard
  @State private var viewModel: WorkspaceDetailViewModel
  
  init(id: UUID) {
    self.id = id
    self._viewModel = State(
      wrappedValue: WorkspaceDetailViewModel(
        workspaceRepository: Container.shared.workspaceRepository.resolve()
      )
    )
    self.viewModel.fetchWorkspaceById(id: id)
  }
    
  let routes: [WorkspaceDetailRoute] = [
    .dashboard,
    .apps,
    .languages,
    .translations,
    .variables,
    .users,
    .settings
  ]
  
  var body: some View {
    ViewStateUIBuilder(
      state: viewModel.viewState
    ) {
      CenteredProgressView()
    } forError: { error in
      Text(error)
    } forData: { data in
      WorkspaceNavView(data: data)
    } forNoData: {
      Text("Unable to show workspace details")
    }
    .navigationTitle("Workspace Detail")
    .toolbar {
      BackNavButton {
        router.pop()
      }
    }
  }
  
  func WorkspaceNavView(data: WorkspaceDTO) -> some View {
    NavigationSplitView {
      List(routes, id: \.self, selection: $selectedTab) { route in
        Label(route.title(), systemImage: route.iconName())
      }
    } detail: {
      switch selectedTab {
        case .dashboard:
          WSDashboardScreen(data: data)
        case .apps:
          WSAppsScreen(data: data)
        case .variables:
          WSVariablesScreen(data: data)
        case .languages:
          WSLanguagesScreen(data: data)
        case .translations:
          WSTranslationsScreen(data: data)
        case .users:
          WSUsersScreen(data: data)
        case .settings:
          WSSettingsScreen(data: data)
      }
    }
  }
}

#Preview {
  WorkspaceDetailScreen(id: UUID())
}
