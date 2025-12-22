//
//  AddGroupForm.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 03/12/25.
//

import AppKit
import SwiftUI

func showCustomDialog<Content: View>(
  @ViewBuilder content: @escaping () -> Content
) {
  let hosting = NSHostingController(rootView: content())
  let window = NSWindow(
    contentRect: NSRect(x: 0, y: 0, width: 300, height: 200),
    styleMask: [.titled, .closable],
    backing: .buffered,
    defer: false
  )

  window.center()
  window.title = "New Group"
  window.contentView = hosting.view
  window.isReleasedWhenClosed = false
  window.makeKeyAndOrderFront(nil)
}

struct AddGroupForm: View {
  let apiResult: Binding<ViewState<String>>
  let parentGroupID: UUID?
  let allGroups: [TranslationGroupDTO]
  @State private var name = ""
  var onClose: () -> Void
  let onSubmit: (String, UUID?) -> Void
  
  func getParentGroupName() -> String? {
    if parentGroupID == nil {
      return nil
    }
    
    let parentId = parentGroupID!
    
    var hierarchy: [String] = []
    var currentId: UUID? = parentId

    while currentId != nil {
      let currentGroup = allGroups.first(where: { $0.id == currentId! })
      if currentGroup == nil {
        return nil
      }
      hierarchy.append(currentGroup!.key)
      currentId = currentGroup!.parentGroupId
    }

    return hierarchy.reversed().joined(separator: " > ")
  }

  var body: some View {
    return VStack(alignment: .leading, spacing: 12) {
      if getParentGroupName() != nil {
        Text(getParentGroupName() ?? "")
          .font(.title2)
          .padding(.bottom, 8)
      }

      TextField("Group Name", text: $name)
        .textFieldStyle(.roundedBorder)
      
      if apiResult.wrappedValue.hasError {
        Text(
          apiResult.wrappedValue.error ?? "Something went wrong. Please try again."
        )
        .foregroundColor(.red)
        .multilineTextAlignment(.leading)
        .lineLimit(nil)
        .fixedSize(horizontal: false, vertical: true)
      }
      
      HStack {
        Spacer()
        
        Button("Cancel") { onClose() }
          .disabled(apiResult.wrappedValue.loading)

        
        Button(action: {
          onSubmit(name, parentGroupID)
        }) {
          if apiResult.wrappedValue.loading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle())
          } else {
            Text("Submit")
          }
        }
        .disabled(apiResult.wrappedValue.loading)
        .keyboardShortcut(.defaultAction)
      }
    }
    .padding()
    .frame(width: 280)
  }
}
