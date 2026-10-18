//
//  ViewStateUIBuilder.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 12/09/25.
//

import SwiftUI

struct ViewStateUIBuilder<
  T,
  LoadingView: View,
  ErrorView: View,
  DataView: View,
  NoDataView: View
>: View {

  let state: ViewState<T>

  let forLoading: () -> LoadingView
  let forError: (_ error: String) -> ErrorView
  let forData: (_ data: T) -> DataView
  let forNoData: () -> NoDataView

  /// A small, cheap "which branch are we on" key purely so .animation(value:)
  /// has something Equatable to watch - this is what makes switching
  /// between loading/data/empty animate instead of just popping in.
  private var phaseKey: Int {
    if state.loading { return 0 }
    if state.hasError { return 1 }
    if state.hasData { return 2 }
    return 3
  }

  var body: some View {
    Group {
      if state.loading {
        forLoading()
          .transition(.opacity)
      } else if state.hasError, let error = state.error {
        forError(error)
          .transition(.opacity)
      } else if state.hasData, let data = state.data {
        forData(data)
          .transition(.opacity.combined(with: .scale(scale: 0.98, anchor: .top)))
      } else {
        forNoData()
          .transition(.opacity)
      }
    }
    .animation(.easeOut(duration: 0.25), value: phaseKey)
  }
}
