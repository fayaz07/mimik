//
//  ViewState.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 11/09/25.
//


struct ViewState<T> {
  var loading: Bool = false
  var error: String? = nil
  var success: Bool = false
  var data: T? = nil
  
  init(
    loading: Bool,
    data: T? = nil,
    error: String? = nil,
    isSuccess: Bool = false
  ) {
    self.loading = loading
    self.data = data
    self.error = error
    self.success = isSuccess
  }

  var hasData: Bool {
    return data != nil
  }
  
  var hasError: Bool {
    return error != nil
  }
  
  var isSuccess: Bool {
    return hasData && !hasError
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
    ViewState(loading: false, data: data, isSuccess: true)
  }

  static func failure(error: String) -> ViewState<T> {
    ViewState(loading: false, error: error)
  }
}
