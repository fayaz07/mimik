//
//  TrslnGroupDetailView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 29/04/26.
//

import SwiftUI
import Factory

struct TrslnGroupDetailView: View {
  
  let isWorkspaceRoot: Bool
  let workspaceId: UUID
  let currentGroup: TranslationGroupDTO
  let parentGroups: [BreadcrumbItem]
  
  @Injected(\.trslnGroupDetailViewModel)
  var viewModel: TrslnGroupDetailViewModel
  
  var body: some View {
    VStack {
      // Text("\(currentGroup.key) \(currentGroup.workspaceId)")
      
      ViewStateUIBuilder(state: viewModel.childGroups) {
        ProgressView()
      } forError: { error in
        Text(error)
      } forData: { data in
        return VStack {
          GroupBreadcrumb(
            group: currentGroup,
            parentGroups: parentGroups
          )
          Spacer()
        }
      } forNoData: {
        Text("Unable to fetch Translation Groups")
      }
    }.onAppear {
      viewModel.load(
        groupId: currentGroup.id,
        workspaceId: workspaceId,
        isWorkspaceRoot: isWorkspaceRoot
      )
    }
  }
}

#Preview {
  //  TrslnGroupDetailView()
}
