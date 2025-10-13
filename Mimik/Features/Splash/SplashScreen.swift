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
    .background(.white)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//      DispatchQueue.main.async {
        // navigate to dashboard
        router.setRoot(to: .dashboard)
      }
    }
  }
}

#Preview {
  SplashScreen()
}
