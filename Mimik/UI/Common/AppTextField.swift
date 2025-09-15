//
//  AppTextField.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/08/25.
//

import SwiftUI

extension View {
  func appTextFieldStyle() -> some View {
    self
      .textFieldStyle(.roundedBorder)
      .font(.body)
  }
    
  func minusTopPadding() -> some View {
    self
      .padding(.top, -4)
  }
}

struct AppTextField: View {
  let label: String
  let value: Binding<String>
  let error: Binding<String?>
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(label)
        .padding(.leading, 8)
      
      TextField("", text: value)
        .appTextFieldStyle()
        .minusTopPadding()
      
      if let err = error.wrappedValue, !err.isEmpty {
        Text(err)
          .foregroundColor(.red)
          .font(.caption)
          .padding(.leading, 8)
      }
    }
  }
}

#Preview {
  TextField("", text: .constant("Hello"))
    .padding()
    .appTextFieldStyle()
  
  AppTextField(
    label: "Name",
    value: .constant("Rahul Gandhi"),
    error: .constant(nil)
  ).padding()
  
  AppTextField(
    label: "Name",
    value: .constant("Rahul Gandhi"),
    error: .constant("Prime Minister of India")
  ).padding()
}
