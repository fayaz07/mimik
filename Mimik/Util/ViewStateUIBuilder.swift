//
//  ViewStateUIBuilder.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 12/09/25.
//

import SwiftUI

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

  var body: some View {
    if state.loading {
      forLoading()
    } else if state.hasError, let error = state.error {
      forError(error)
    } else if state.hasData, let data = state.data {
      forData(data)
    } else {
      forNoData()
    }
  }
}
