//
//  WorkspaceCardView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 13/09/25.
//

import SwiftUI
import CoreData

struct WorkspaceCardView: View {
  var data: WorkspaceEntity
  var showLastAccessed: Bool = false
  var onClick: (WorkspaceEntity) -> Void
  
  var body: some View {
    Button(action: { onClick(data) }) {
      content
    }
    .buttonStyle(PlainButtonStyle())
    .frame(width: 250, height: 150)
  }
  
  var content: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(.white)
        .shadow(radius: 4)

      HStack {
        VStack(alignment: .leading) {
          Text(data.name)
            .font(.headline)
            .foregroundStyle(.black)
            .lineLimit(1)

          Spacer()
          if showLastAccessed {
            Text(
              "Last accessed: \(customRelativeTimeString(from: data.lastAccessed ?? Date()))"
            )
            .font(.caption)
            .foregroundColor(.secondary)
          }
        }
        .padding(16)
        .multilineTextAlignment(.center)
        
        Spacer()
      }
    }
  }
}

struct AddWorkspaceCardView: View {
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(.white)
          .shadow(radius: 4)
        
        content
      }
    }
    .buttonStyle(PlainButtonStyle())
    .frame(width: 250, height: 150)
  }
  
  var content: some View {
    HStack {
      VStack {
        Spacer()
        Text("Add Workspace")
          .font(.headline)
          .foregroundStyle(.black)
          .lineLimit(1)
        Image(systemName: "plus")
          .font(.system(size: 24, weight: .bold))
          .padding(.top, 4)
        Spacer()
      }
      .padding(16)
      .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  // 1. Create a mock in-memory Core Data container for the preview
  let container = NSPersistentContainer(
    name: "YourDataModelName"
  ) // Replace with your model name
  let description = NSPersistentStoreDescription()
  description.url = URL(fileURLWithPath: "/dev/null") // Use an in-memory store
  container.persistentStoreDescriptions = [description]
  container.loadPersistentStores { _, error in
    if let error = error {
      fatalError("Failed to load stores: \(error)")
    }
  }

  // 2. Get the mock context
  let viewContext = container.viewContext

  // 3. Create a valid instance of WorkspaceEntity within the context
  let workspace = WorkspaceEntity(context: viewContext)
  workspace.id = UUID()
  workspace.name = "Workspace 1"
  workspace.desc = "Workspace 1 Description"

  // 4. Pass the valid instance to your view
  return VStack {
    WorkspaceCardView(data: workspace, onClick: { _ in })
    
    WorkspaceCardView(data: workspace, showLastAccessed: true, onClick: { _ in })
    
    AddWorkspaceCardView {
      
    }
  }
}
