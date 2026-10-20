//
//  GroupFolderCardView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import SwiftUI

struct GroupFolderCardView: View {
  let group: TranslationGroupDTO
  var onClick: (TranslationGroupDTO) -> Void

  @State private var isHovered = false

  var body: some View {
    Button(action: { onClick(group) }) {
      content
    }
    .buttonStyle(PlainButtonStyle())
    .frame(width: 200, height: 128)
    .scaleEffect(isHovered ? 1.03 : 1.0)
    .shadow(color: .black.opacity(isHovered ? 0.12 : 0.05), radius: isHovered ? 10 : 5, y: isHovered ? 5 : 3)
    .animation(.easeOut(duration: 0.15), value: isHovered)
    .onHover { isHovered = $0 }
  }

  var content: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .fill(.white)

      RoundedRectangle(cornerRadius: 16)
        .stroke(isHovered ? AppColors.primaryStart.opacity(0.4) : AppColors.cardBorder, lineWidth: 1)

      VStack(alignment: .leading, spacing: 10) {
        HStack {
          ZStack {
            RoundedRectangle(cornerRadius: 10)
              .fill(AppColors.primaryGradient)
              .frame(width: 36, height: 36)

            Image(systemName: "folder.fill")
              .font(.system(size: 16))
              .foregroundStyle(.white)
          }

          Spacer()

          Image(systemName: "chevron.right")
            .font(.caption.weight(.semibold))
            .foregroundStyle(isHovered ? AppColors.primaryStart : Color.secondary)
        }

        Spacer()

        Text(group.displayLabel)
          .font(.headline)
          .foregroundStyle(.black)
          .lineLimit(1)
          .truncationMode(.tail)
          .help(group.displayLabel)

        Text("Created \(customRelativeTimeString(from: group.createdAt))")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding(16)
    }
  }
}

#Preview {
  GroupFolderCardView(
    group: TranslationGroupDTO(
      id: UUID(),
      workspaceId: UUID(),
      key: "auth",
      parentGroupId: nil,
      createdAt: Date(),
      updatedAt: Date()
    ),
    onClick: { _ in }
  )
  .padding()
  .background(AppColors.canvasBackground)
}
