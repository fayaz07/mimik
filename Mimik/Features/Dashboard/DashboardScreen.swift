//
//  DashboardView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI
import Factory
import Flow

struct DashboardScreen: View {
  
  @EnvironmentObject var router: AppNavigationRouter
  @InjectedObject(\.dashboardViewModel) private var viewModel
  @Environment(\.managedObjectContext) var moc
    
  var body: some View {
    ScrollView {
      recentWorkspacesSection
        .navigationTitle(LocalizedStringKey("screen.dashboard"))
        .padding(16)
    }.background(.white)
  }
   
  var recentWorkspacesSection: some View {
    VStack {
      HStack {
        Text("Recent Workspaces")
          .font(.title)
          .padding(.top, 16)
        Spacer()
      }.padding(0)
      
      ViewStateUIBuilder(
        state: viewModel.workspaces,
        forLoading: {
          ProgressView()
        },
        forError: { error in
          Text("Error: \(error)")
        },
        forData: { items in
          workspacesList(items: items)
        },
        forNoData: {
          Text("No items found.")
        }
      ).padding(0)
    }
  }
  
  private func onAddWorkspace() {
    router.push(to: .workspace(.add))
  }
  
  @ViewBuilder
  private func workspacesList(items: [WorkspaceEntity]) -> some View {
    VStack(alignment: .leading) {
      if items.isEmpty {
        Text("No items found.")
      } else {
        HStack {
          HFlow(alignment: .firstTextBaseline, spacing: 16) {
            ForEach(items, id: \.self) { item in
              WorkspaceCardView(data: item) { _ in
                
              }
            }
            AddWorkspaceCardView(action: onAddWorkspace)
          }
          Spacer()
        }
      }
    }.padding(0)
  }
}

#Preview {
  DashboardScreen()
}
