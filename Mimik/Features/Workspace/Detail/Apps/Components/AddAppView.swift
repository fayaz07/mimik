//
//  AddAppView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

import SwiftUI

struct AddAppView: View {
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      ZStack {
        RoundedRectangle(cornerRadius: 16)
          .fill(.white)
          .shadow(radius: 4)
        
        content
      }
    }
    .buttonStyle(PlainButtonStyle())
    .frame(width: 250, height: 150)
  }
  
  var content: some View {
    HStack {
      VStack {
        Spacer()
        Text("Add App")
          .font(.headline)
          .foregroundStyle(.black)
          .lineLimit(1)
        Image(systemName: "plus")
          .font(.system(size: 24, weight: .bold))
          .padding(.top, 4)
        Spacer()
      }
      .padding(16)
      .multilineTextAlignment(.center)
    }
  }
}
