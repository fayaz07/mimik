//
//  ViewEvent.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 15/10/25.
//

struct ViewEvent<T: Equatable>: Equatable {
  let isError: Bool
  let data: T?
  
  init(isError: Bool, data: T?) {
    self.isError = isError
    self.data = data
  }
  
  // ✅ Add this for convenience
  static func push(_ data: T) -> ViewEvent<T> {
    ViewEvent(isError: false, data: data)
  }

  static func error(_ data: T) -> ViewEvent<T> {
    ViewEvent(isError: true, data: data)
  }

  static func none() -> ViewEvent<T> {
    ViewEvent(isError: false, data: nil)
  }
}
