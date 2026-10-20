//
//  AppInclusionPicker.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import SwiftUI
import Flow

/// A row of toggle chips, one per app in the workspace, showing whether a
/// translation key is included in that app (the default) or excluded from
/// it - e.g. two Android apps in the same workspace ("Driver", "Customer")
/// that need mostly-separate translation sets.
///
/// Purely presentational: the caller decides what tapping a chip means,
/// whether that's just flipping a not-yet-saved local selection (building a
/// new key) or persisting the change immediately (an existing key).
struct AppInclusionPicker: View {
  let apps: [WSAppDTO]
  let excludedAppIds: Set<UUID>
  var isDisabled: Bool = false
  var onToggle: (WSAppDTO) -> Void

  var body: some View {
    if !apps.isEmpty {
      HFlow(spacing: 6) {
        ForEach(apps) { app in
          let isIncluded = !excludedAppIds.contains(app.id)
          Button(action: { onToggle(app) }) {
            HStack(spacing: 5) {
              Image(SupportedPlatforms.getImage(for: app.appPlatformId))
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .saturation(isIncluded ? 1 : 0)
                .opacity(isIncluded ? 1 : 0.4)

              Text(app.name)
                .font(.caption2.weight(.medium))
                .lineLimit(1)
            }
            .foregroundStyle(isIncluded ? AppColors.primaryStart : Color.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
              Capsule().fill(isIncluded ? AppColors.primaryStart.opacity(0.1) : Color.gray.opacity(0.08))
            )
            .overlay(
              Capsule().stroke(
                isIncluded ? AppColors.primaryStart.opacity(0.4) : AppColors.cardBorder,
                lineWidth: 1
              )
            )
          }
          .buttonStyle(.plain)
          .disabled(isDisabled)
        }
      }
    }
  }
}

#Preview {
  AppInclusionPicker(
    apps: [
      WSAppDTO(
        id: UUID(), name: "Driver", desc: "", workspaceId: UUID(),
        appPlatformId: SupportedPlatforms.ANDROID.id,
        createdAt: Date(), updatedAt: Date(), lastAccessed: Date()
      ),
      WSAppDTO(
        id: UUID(), name: "Customer", desc: "", workspaceId: UUID(),
        appPlatformId: SupportedPlatforms.ANDROID.id,
        createdAt: Date(), updatedAt: Date(), lastAccessed: Date()
      )
    ],
    excludedAppIds: [],
    onToggle: { _ in }
  )
  .padding()
  .background(AppColors.canvasBackground)
}
