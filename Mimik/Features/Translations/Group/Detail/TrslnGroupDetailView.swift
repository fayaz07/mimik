//
//  TrslnGroupDetailView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 29/04/26.
//

import SwiftUI

struct TrslnGroupDetailView: View {
    
  let currentGroup: TranslationGroupDTO
  let parentGroups: [BreadcrumbItem]
  
  var body: some View {
    Text("Hello, World!")
    Text(currentGroup.key)
  }
}

#Preview {
  TrslnGroupDetailView()
}
