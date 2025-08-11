//
//  TextButton.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/08/25.
//

import SwiftUI

struct FilledButton: View {
  let text: String
  var width: CGFloat?
  let onTap: () -> Void
  
  var body: some View {
    Button(action: onTap) {
      Text(text)
        .foregroundColor(.white)
        .frame(maxWidth: width)
        .padding(.vertical, 12)
        .padding(.horizontal, 40)
        .background(Color.blue)
        .cornerRadius(6)
    }
    .buttonStyle(PlainButtonStyle())
  }
}

#Preview {
  FilledButton(
    text: "Filled Button") {
      
    }.padding()
}
