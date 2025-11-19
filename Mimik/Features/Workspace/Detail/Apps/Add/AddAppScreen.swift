//
//  AddAppScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

import SwiftUI
import Factory

struct AddAppScreen: View {
  @EnvironmentObject private var router: AppNavigationRouter
  @State private var viewModel: AddAppViewModel
  
  init() {
    self._viewModel = State(
      wrappedValue: AddAppViewModel(
        workspaceRepository: Container.shared.workspaceRepository.resolve()
      )
    )
  }
  
  var body: some View {
    VStack {
      AddAppForm(viewModel: viewModel)
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
          router.push(to: .workspace(.detail(id: id)), replace: true)
      }
    }
  }
}
