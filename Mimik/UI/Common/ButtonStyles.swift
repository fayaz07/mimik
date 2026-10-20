//
//  ButtonStyles.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 03/09/26.
//
import SwiftUI

/// A filled, gradient capsule button - the app's primary-action style (e.g.
/// "Add Group", "Add Key").
struct GradientPillButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.subheadline.weight(.semibold))
      .foregroundColor(.white)
      .padding(.horizontal, 18)
      .padding(.vertical, 10)
      .background(AppColors.primaryGradient)
      .clipShape(Capsule())
      .shadow(
        color: AppColors.primaryStart.opacity(0.35),
        radius: configuration.isPressed ? 2 : 6,
        y: configuration.isPressed ? 1 : 3
      )
      .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
      .opacity(configuration.isPressed ? 0.9 : 1.0)
  }
}

/// A low-emphasis capsule button tinted with a caller-supplied color - used
/// for secondary actions like "Cancel", "Rename", or "Delete".
struct GhostButtonStyle: ButtonStyle {
  var color: Color

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.subheadline.weight(.medium))
      .foregroundColor(color)
      .padding(.horizontal, 14)
      .padding(.vertical, 9)
      .background(
        Capsule().fill(color.opacity(configuration.isPressed ? 0.16 : 0.08))
      )
      .opacity(configuration.isPressed ? 0.85 : 1.0)
  }
}
