//
//  WorkspaceUsersScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI

struct WorkspaceVariablesScreen: View {
  var data: WorkspaceDTO
  
  var body: some View {
    VStack {
      content
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.white)
    .navigationTitle("Apps - \(data.name)")
  }
  
  var content: some View {
    VStack {
      Text("hello")
    }
    .padding(8)
  }
}

#Preview {
//  WorkspaceUsersScreen(id: UUID())
}
