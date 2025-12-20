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
  
  var translations: some View {
    ViewStateUIBuilder(state: viewModel.groups) {
      ProgressView()
    } forError: { error in
      Text(error)
    } forData: { allGroups in
      return TranslationTree(
        rootGroup: allGroups.0,
        groups: allGroups.1
      )
    } forNoData: {
      Text("No groups, please add a group")
    }
    .onAppear {
      viewModel.fetchGroups(workspaceId: data.id)
    }
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
          showCustomDialog {
            AddGroupForm(
              parentGroupID: nil,
              allGroups: [],
              onClose:{
                NSApp.keyWindow?.close()
              }
            ) { name, _ in
              print("Adding group with name: \(name)")
            }
          }
        }
        .buttonStyle(.bordered)
        .tint(.blue)
        .padding(.vertical, 5)
      }
    }
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
            showCustomDialog {
              AddGroupForm(
                parentGroupID: parentGroupId,
                allGroups: groups,
                onClose: {
                  // close callback
                  NSApp.keyWindow?.close()
                }
              ) { name, _ in
                
              }
            }
            //            viewModel
            //              .addGroup(
            //                workspaceId: data.id,
            //                name: name,
            //                parentId: parentGroupId
            //              )
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
  
  var body: some View {
    ScrollView {
      translations
    }
  }
}

#Preview {
  //  WorkspaceTranslationsScreen(id: UUID())
}
