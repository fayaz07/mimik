//
//  TextButton.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/08/25.
//

import SwiftUI

struct TextButton: View {
  let text: String
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
      Text(text)
        .padding(.zero)
        .foregroundColor(.blue)
        .padding(.vertical, 10)
        .padding(.horizontal, 40)
    }.overlay(
      RoundedRectangle(cornerRadius: 6)
        .stroke(Color.blue, lineWidth: 1)
    )
  }
}

#Preview {
  TextButton(
    text: "Text Button", onTap: {}
  ).padding()
}
