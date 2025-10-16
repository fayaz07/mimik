//
//  CenteredProgressView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI

struct CenteredProgressView: View {
  var body: some View {
    HStack {
      Spacer()
      VStack {
        Spacer()
        ProgressView()
        Spacer()
      }
      Spacer()
    }
  }
}

#Preview {
  CenteredProgressView()
}
