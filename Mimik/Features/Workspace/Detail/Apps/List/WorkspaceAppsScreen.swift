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

struct WorkspaceAppsScreen: View {
  @EnvironmentObject private var router: AppNavigationRouter
  
  @Injected(\.workspaceAppsViewModel)
  private var viewModel: WorkspaceAppsViewModel
  
  var data: WorkspaceDTO
  
  var body: some View {
    ScrollView {
      content
        .padding(16)
    }
    .navigationTitle("Apps - \(data.name)")
    .background(.white)
      .onAppear {
        viewModel.fetchWorkspaceApps(workspaceId: data.id)
      }
      .onChange(of: router.currentScreen) { _, newPath in
        if newPath == .home {
          viewModel.fetchWorkspaceApps(workspaceId: data.id)
        }
      }
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
    router.push(to: .workspace(.apps(.add(workspaceId: data.id))))
  }
  
  private func onAppClicked(data: WorkspaceAppDTO) {
    
  }
  
  @ViewBuilder
  private func AppsListBuilder(items: [WorkspaceAppDTO]) -> some View {
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
