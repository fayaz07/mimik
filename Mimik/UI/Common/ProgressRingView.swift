//
//  ProgressRingView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import SwiftUI

/// A small circular completion ring - red while mostly untranslated, amber
/// once it's underway, green (with a checkmark) once everything is done.
struct ProgressRingView: View {
  /// 0...1
  let progress: Double
  var lineWidth: CGFloat = 3.5

  private var clamped: Double {
    min(max(progress, 0), 1)
  }

  private var tint: Color {
    if clamped >= 1 { return AppColors.success }
    if clamped >= 0.5 { return AppColors.warning }
    if clamped > 0 { return AppColors.danger }
    return Color.gray.opacity(0.35)
  }

  var body: some View {
    ZStack {
      Circle()
        .stroke(Color.gray.opacity(0.12), lineWidth: lineWidth)

      Circle()
        .trim(from: 0, to: clamped)
        .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        .rotationEffect(.degrees(-90))
        .animation(.easeOut(duration: 0.35), value: clamped)

      if clamped >= 1 {
        Image(systemName: "checkmark")
          .font(.system(size: 10, weight: .heavy))
          .foregroundStyle(AppColors.success)
      } else {
        Text("\(Int((clamped * 100).rounded()))")
          .font(.system(size: 9, weight: .bold))
          .foregroundStyle(.secondary)
      }
    }
  }
}

#Preview {
  HStack(spacing: 16) {
    ProgressRingView(progress: 0).frame(width: 32, height: 32)
    ProgressRingView(progress: 0.3).frame(width: 32, height: 32)
    ProgressRingView(progress: 0.6).frame(width: 32, height: 32)
    ProgressRingView(progress: 1).frame(width: 32, height: 32)
  }
  .padding()
}
