//
//  PlatformOptionView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import SwiftUI

/// One selectable platform card in the Add App platform picker - replaces
/// the old dropdown Picker with the same tappable-card language used
/// elsewhere (GroupFolderCardView, AddGroupCardView).
struct PlatformOptionView: View {
  let platform: MimikPlatformType
  let isSelected: Bool
  let onSelect: () -> Void

  var body: some View {
    Button(action: onSelect) {
      VStack(spacing: 8) {
        Image(platform.icon)
          .resizable()
          .scaledToFit()
          .frame(width: 32, height: 32)

        Text(platform.name)
          .font(.caption.weight(.medium))
          .foregroundStyle(isSelected ? AppColors.primaryStart : Color.secondary)
          .lineLimit(1)
      }
      .frame(width: 84, height: 84)
      .background(
        RoundedRectangle(cornerRadius: 14)
          .fill(isSelected ? AppColors.primaryStart.opacity(0.08) : Color.white)
      )
      .overlay(
        RoundedRectangle(cornerRadius: 14)
          .stroke(
            isSelected ? AppColors.primaryStart : AppColors.cardBorder,
            lineWidth: isSelected ? 1.5 : 1
          )
      )
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  HStack(spacing: 12) {
    PlatformOptionView(
      platform: SupportedPlatforms.ANDROID,
      isSelected: true,
      onSelect: {}
    )
    PlatformOptionView(
      platform: SupportedPlatforms.ANDROID,
      isSelected: false,
      onSelect: {}
    )
  }
  .padding()
  .background(AppColors.canvasBackground)
}
