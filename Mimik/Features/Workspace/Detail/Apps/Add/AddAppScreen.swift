//
//  AddAppScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

import SwiftUI
import Factory

struct AddAppScreen: View {
  var workspaceId: UUID
  
  @EnvironmentObject private var router: AppNavigationRouter

  @Injected(\.addAppViewModel)
  private var viewModel: AddAppViewModel
  
  var body: some View {
    VStack {
      AddAppForm(
        workspaceId: workspaceId,
        viewModel: viewModel
      )
    }
    .background(.white)
    .navigationTitle("Add App")
    .toolbar {
      BackNavButton {
        router.pop()
      }
    }
    .onChange(of: viewModel.viewEvents) { _, newEvent in
      guard let eventData = newEvent.data else { return }
      
      switch eventData {
        case .created(let id):
//          router.push(to: .workspace(.detail(id: id)), replace: true)
          router.pop()
      }
    }
  }
}
