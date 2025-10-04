//
//  AppTextField.swift
//  Mimik
//
//  Created by Mohammad Fayaz on 11/08/25.
//

import SwiftUI

struct AppTextEditor: View {
  let label: String
  let value: Binding<String>
  let error: Binding<String?>
  var height: CGFloat? = nil
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(label)
      
      TextEditor(text: value)
        .font(.body)
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(Color.white)
        .scrollContentBackground(.hidden)
        .frame(height: height ?? 50)
        .cornerRadius(6)
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(Color.gray.opacity(0.3))
        )
      
      if let err = error.wrappedValue, !err.isEmpty {
        Text(err)
          .foregroundColor(.red)
          .font(.footnote)
          .padding(.leading, 8)
      }
    }
  }
}

#Preview {
  AppTextEditor(
    label: "Name",
    value: .constant("Rahul Gandhi"),
    error: .constant(nil)
  ).padding()
  
  AppTextEditor(
    label: "Name",
    value: .constant("Rahul Gandhi"),
    error: .constant("Prime Minister of India")
  ).padding()
}
