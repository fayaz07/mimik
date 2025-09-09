//
//  SplashScreen.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 07/09/25.
//

import SwiftUI

struct SplashScreen: View {
  @State private var shouldNavigate = false
  
  var body: some View {
    VStack {
      Image(Assets.Images.logo)
        .resizable()
        .scaledToFit()
        .frame(width: 150, height: 150)
                    
      Text(Constants.appName)
        .font(.title)
        .bold()
        .padding(.top, Padding.sm)
    }
    .onAppear {
      // Add a 2-second delay
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
        self.shouldNavigate = true
      }
    }

    NavigationLink(destination: DashboardView(), isActive: $shouldNavigate) {
      EmptyView()
    }
  }
}

#Preview {
  SplashScreen()
}
