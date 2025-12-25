//
//  AddTranslationGroupScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 23/12/25.
//

import SwiftUI
import Factory

struct AddTranslationGroupScreen: View {
  
  @Injected(\.addTrslnGroupViewModel)
  var viewModel: AddTranslationGroupViewModel
  
  @EnvironmentObject var router: AppNavigationRouter
  
  let workspaceId: UUID
  let parentGroupID: UUID?
  let allGroups: [TranslationGroupDTO]
  
  func getParentGroupName() -> String {
    if parentGroupID == nil {
      return "Root"
    }
    
    let parentId = parentGroupID!
    
    var hierarchy: [String] = []
    var currentId: UUID? = parentId

    while currentId != nil {
      let currentGroup = allGroups.first(where: { $0.id == currentId! })
      if currentGroup == nil {
        return "Root"
      }
      hierarchy.append(currentGroup!.key)
      currentId = currentGroup!.parentGroupId
    }

    return hierarchy.reversed().joined(separator: " > ")
  }

  
  var body: some View {
    @Bindable var vm = viewModel
    let loading = vm.addGroupResult.loading
    
    return VStack(alignment: .leading, spacing: 12) {

      Text(getParentGroupName())
        .font(.title2)
        .padding(.bottom, 8)

      TextField("Group Name", text: $vm.currentGroupName)
        .textFieldStyle(.roundedBorder)
      
      if vm.addGroupResult.hasError {
        Text(
          vm.addGroupResult.error ?? "Something went wrong. Please try again."
        )
        .foregroundColor(.red)
        .multilineTextAlignment(.leading)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
      }
      
      HStack {
        Spacer()
        
        Button("Cancel") { router.pop() }
          .disabled(loading)
        
        Button(action: {
          viewModel.addGroup(workspaceId: workspaceId, parentId: parentGroupID)
        }) {
          if loading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
          } else {
            Text("Submit")
          }
        }
        .disabled(loading)
        .keyboardShortcut(.defaultAction)
      }
      
      Spacer()
    }
    .background(.white)
    .navigationTitle("Add Translation Group")
    .toolbar {
      BackNavButton {
        router.pop()
      }
    }
    .padding()
    .onReceive(viewModel.$addGroupEvent) { event in
      switch event.data {
        case .added:
          router.pop()
        default:
          break
      }
    }
  }
}

#Preview {
  //  AddTranslationGroupScreen()
}
