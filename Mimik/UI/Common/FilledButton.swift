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
  var loading: Bool = false
  var bgColor: Color = Color.blue
  let onTap: () -> Void
  
  var body: some View {
    if loading {
      loadingState
    } else {
      normalState
    }
  }
  
  var normalState: some View {
    Button(action: onTap) {
      Text(text)
        .foregroundColor(.white)
        .frame(maxWidth: width)
        .padding(.vertical, 12)
        .padding(.horizontal, 40)
        .background(bgColor)
        .cornerRadius(6)
    }
    .buttonStyle(PlainButtonStyle())
  }
  
  var loadingState: some View {
    Button(action: {}) {
      HStack {
        ProgressView()
          .scaleEffect(0.5)
          .foregroundStyle(Color.white)
          .padding(0)
        Text(text)
          .padding(0)
          .foregroundColor(.white)
      }
      .frame(maxWidth: width)
      .padding(.vertical, 4.5)
      .padding(.horizontal, 12)
    }
    .disabled(true)
    .background(.gray)
    .cornerRadius(6)
  }
}

#Preview {
  return VStack {
    FilledButton(
      text: "Loading button",
      loading: true
    ) { }.padding()
      
    FilledButton(
      text: "Filled Button",
    ) { }.padding()
      
    FilledButton(
      text: "Danger Button",
      bgColor: Color.red
    ) { }.padding()
  }
}
