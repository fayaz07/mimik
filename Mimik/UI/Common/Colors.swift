//
//  Colors.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI

struct AppColors {
  static let primaryStart = Color(red: 0.46, green: 0.39, blue: 0.98)
  static let primaryEnd = Color(red: 0.29, green: 0.58, blue: 0.97)

  static let primaryGradient = LinearGradient(
    colors: [primaryStart, primaryEnd],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  static let success = Color(red: 0.20, green: 0.74, blue: 0.47)
  static let warning = Color(red: 0.96, green: 0.65, blue: 0.14)
  static let danger = Color(red: 0.92, green: 0.31, blue: 0.38)

  static let canvasBackground = Color(red: 0.965, green: 0.965, blue: 0.98)
  static let cardBorder = Color.gray.opacity(0.12)
}
