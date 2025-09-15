//
//  SplashScreen.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 07/09/25.
//

import SwiftUI

struct SplashScreen: View {
  @EnvironmentObject var router: AppNavigationRouter
  
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
      
      ProgressView() // Default spinner
        .progressViewStyle(CircularProgressViewStyle())
        .scaleEffect(0.75)
        .padding(.top, Padding.sm)
        .padding(.bottom, Padding.sm)
    }
    .onAppear {
      // Add a 2-second delay
//      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
      DispatchQueue.main.asyncAfter(deadline: .now()) {
        // navigate to dashboard
        router.setRoot(to: AppRoutes.dashboard)
      }
    }
  }
}

#Preview {
  SplashScreen()
}
