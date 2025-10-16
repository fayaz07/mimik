//
//  Snackbar.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//
import SwiftUI

struct Snackbar: View {
  let text: String
  let show: Bool
  
  var body: some View {
    if show {
      VStack {
        Spacer()
        HStack {
          Text(text)
            .foregroundColor(.white)
            .padding(.horizontal)
          Spacer()
        }
        .padding()
        .background(Color.black.opacity(0.85))
        .cornerRadius(12)
        .padding(.horizontal)
        .transition(.move(edge: .bottom).combined(with: .opacity))
        .animation(.easeOut(duration: 0.3), value: show)
      }
    }
  }
}
