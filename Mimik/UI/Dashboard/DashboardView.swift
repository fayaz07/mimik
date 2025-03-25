//
//  DashboardView.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 24/03/25.
//

import SwiftUI

struct DashboardView: View {
  var body: some View {
    content
      .navigationTitle(LocalizedStringKey(SidebarItem.dashboard.title))
  }
  
  var content: some View {
    Text("Hello, World!")
  }
}

#Preview {
  DashboardView()
}
