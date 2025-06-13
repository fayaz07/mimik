//
//  NavButtons.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 13/06/25.
//

import SwiftUI

struct BackNavButton: ToolbarContent {
  var onClick: () -> Void

  var body: some ToolbarContent {
    ToolbarItem(placement: .navigation) {
      Button(action: onClick) {
        Image(systemName: "chevron.left")
          .padding(EdgeInsets(.init(top: 0, leading: 4, bottom: 0, trailing: 4)))
      }
    }
  }
}

struct ForwardNavButton: ToolbarContent {
  var onClick: () -> Void
  
  var body: some ToolbarContent {
    ToolbarItem(placement: .navigation) {
      Button(action: onClick) {
        Image(systemName: "chevron.right")
          .padding(EdgeInsets(.init(top: 0, leading: 4, bottom: 0, trailing: 4)))
      }
    }
  }
}
