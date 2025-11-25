//
//  WorkspaceCardView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 13/09/25.
//

import SwiftUI
import CoreData

struct WorkspaceCardView: View {
  var data: WorkspaceDTO
  var showLastAccessed: Bool = false
  var onClick: (WorkspaceDTO) -> Void
  
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
              "Created at: \(customRelativeTimeString(from: data.createdAt))"
            )
            .font(.caption)
            .foregroundColor(.secondary)
            Text(
              "Last accessed: \(customRelativeTimeString(from: data.lastAccessed))"
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
  let workspace = WorkspaceDTO(
    id: UUID(),
    name: "Workspace 1",
    desc: "",
    createdAt: Date(),
    updatedAt: Date(),
    lastAccessed: Date()
  )
  
  VStack {
    WorkspaceCardView(data: workspace, onClick: { _ in })
    
    WorkspaceCardView(
      data: workspace,
      showLastAccessed: true,
      onClick: { _ in
      })
    
    AddWorkspaceCardView {
      
    }
  }
}
