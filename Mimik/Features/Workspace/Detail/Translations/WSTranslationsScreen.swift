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
  
  @Injected(\.trlsnScreenViewModel)
  var viewModel: WSTranslationsViewModel
  
  
  
  @State private var showDetails: Bool = false
  
  var body: some View {
    ScrollView {
      ViewStateUIBuilder(state: viewModel.groups) {
        ProgressView()
      } forError: { error in
        Text(error)
      } forData: { allGroups in
        return TranslationTree(
          rootGroup: allGroups.0,
          groups: allGroups.1,
        )
      } forNoData: {
        Text("No groups, please add a group")
      }
      .onAppear {
        viewModel.fetchGroups(workspaceId: data.id)
      }
    }.onReceive(viewModel.$addGroupEvent) { event in
      if case .added = event.data {
        closeDialog()
      }
    }
  }

  func showDialog(
    parentGroupId: UUID? = nil,
    groups: [TranslationGroupDTO]
  ) {
    @Bindable var vm = viewModel
    
    showCustomDialog {
      AddGroupForm(
        apiResult: $vm.addGroupResult,
        parentGroupID: parentGroupId,
        allGroups: groups,
        onClose: closeDialog
      ) { name, _ in
        viewModel
          .addGroup(
            workspaceId: data.id,
            name: name,
            parentId: parentGroupId
          )
      }
    }
  }
  
  func closeDialog() {
//    NSApp.keyWindow?.close()
  }
  
  func TranslationTree(
    rootGroup: TranslationGroupDTO,
    groups: [TranslationGroupDTO]
  ) -> some View {
    let parentGroups = groups.filter({ $0.parentGroupId == nil })
    
    return VStack {
      RootGroupView(rootGroup: rootGroup)
      
      ForEach(parentGroups) { group in
        NestedTree(
          level: 0,
          allGroups: groups,
          group: group,
          onAddGroup: { parentGroupId in
            showDialog(parentGroupId: parentGroupId, groups: groups)
          }
        )
      }
    }.padding(8.0)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.gray.opacity(0.4), lineWidth: 1)
      )
      .padding(8.0)
  }

  func RootGroupView(
    rootGroup: TranslationGroupDTO
  ) -> some View {
    return Section {
      HStack {
        Text("Translations at Root")
          .font(.headline)
        Spacer()
        
        Button("Add Translation") {
          
        }
        .buttonStyle(.bordered)
        .tint(.green)
        .padding(.vertical, 5)
        Button("Add Group") {
          showDialog(parentGroupId: nil, groups: [])
        }
        .buttonStyle(.bordered)
        .tint(.blue)
        .padding(.vertical, 5)
      }
    }
  }
}

#Preview {
  //  WorkspaceTranslationsScreen(id: UUID())
}
