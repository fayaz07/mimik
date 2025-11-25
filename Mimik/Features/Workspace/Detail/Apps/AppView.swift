//
//  AppView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 24/11/25.
//

import SwiftUI

struct AppView: View {
  var data: WorkspaceAppDTO
  var onClick: (WorkspaceAppDTO) -> Void
  
  var body: some View {
    Button(action: { onClick(data) }) {
      content
    }
    .buttonStyle(PlainButtonStyle())
    .frame(width: 250, height: 150)
  }
  
  func BottomSection() -> some View {
    return HStack {
      VStack(alignment: .leading) {
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
      
      Spacer()
      
      Image(SupportedPlatforms.getImage(for: data.appPlatformId))
        .resizable()
        .scaledToFit()
        .frame(width: 36, height: 36)
    }
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
          BottomSection()
        }
        .padding(16)
        .multilineTextAlignment(.center)
        
        Spacer()
      }
    }
  }
}

#Preview {
  AppView(
    data: WorkspaceAppDTO(
      id: UUID(),
      name: "Mimik Android",
      desc: "Just an Android app",
      workspaceId: UUID(),
      appPlatformId: SupportedPlatforms.ANDROID.id,
      createdAt: Date(),
      updatedAt: Date(),
      lastAccessed: Date()
    ),
    onClick: ({ _ in })
  )
}
