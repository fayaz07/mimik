//
//  ViewState.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 11/09/25.
//


struct ViewState<T> {
  var loading: Bool = false
  var error: String? = nil
  var data: T? = nil
  
  init(loading: Bool, data: T? = nil, error: String? = nil) {
    self.loading = loading
    self.data = data
    self.error = error
  }

  var hasData: Bool {
    return data != nil
  }
  
  var hasError: Bool {
    return error != nil
  }
}

extension ViewState {
  static func idle() -> ViewState<T> {
    .init(loading: false, data: nil, error: nil)
  }
  
  static func loading() -> ViewState<T> {
    ViewState(loading: true)
  }

  static func success(data: T) -> ViewState<T> {
    ViewState(loading: false, data: data)
  }

  static func failure(error: String) -> ViewState<T> {
    ViewState(loading: false, error: error)
  }
}
