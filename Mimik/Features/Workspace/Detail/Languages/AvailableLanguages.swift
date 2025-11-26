//
//  AvailableLangs.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 26/11/25.
//

import SwiftUI

private let _columns : [GridItem] = [
  GridItem(.fixed(30), alignment: .trailing),
  GridItem(.fixed(50), alignment: .leading),
  GridItem(.flexible(minimum: 100), alignment: .leading),
  GridItem(.flexible(minimum: 40), alignment: .leading),
  GridItem(.flexible(minimum: 40), alignment: .center)
]

struct AvailableLanguages: View {
  let data: [String: LangDTO]
  let onAdd: (LangDTO) -> Void
    
  @State private var query = ""
    
  var filteredList: [LangDTO] {
    let list = Array(data.values).sorted { a,b in
      a.code.lowercased() < b.code.lowercased()
    }

    guard !query.isEmpty else { return list }

    let q = query.lowercased()
    return list.filter {
      $0.code.lowercased().contains(q) ||
      $0.name.lowercased().contains(q)
    }
  }
    
  var body: some View {
    VStack(spacing: 0) {
      // 🔎 Search bar
      HStack {
        TextField("Search language…", text: $query)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .padding(.vertical, 6)
          .padding(.horizontal, 4)
                
        if !query.isEmpty {
          Button {
            query = ""
          } label: {
            Image(systemName: "xmark.circle.fill")
          }
          .buttonStyle(.plain)
        }
      }
      .padding(.bottom, 8)

      // Header
      LazyVGrid(columns: _columns, spacing: 0) {
        Text("#").bold().padding(.vertical, 5)
        Text("Code").bold().padding(.vertical, 5)
        Text("Name").bold().padding(.vertical, 5)
        Text("Direction").bold().padding(.vertical, 5)
        Text("Actions").bold().padding(.vertical, 5)
      }
      Divider()

      // Rows
      ForEach(Array(filteredList.enumerated()), id: \.offset) { index, item in
        LazyVGrid(columns: _columns, spacing: 0) {
          Text("\(index + 1)").padding(.vertical, 5)
          Text(item.code).padding(.vertical, 5)
          Text(item.name).padding(.vertical, 5)
          Text(item.rtl ? "Right to Left" : "Left to Right")
            .padding(.vertical, 5)

          Button("Add") {
            onAdd(item)
          }
          .buttonStyle(.borderedProminent)
          .padding(.vertical, 5)
        }
        .background(index % 2 == 0 ? Color.white : Color.gray.opacity(0.1))
      }
    }
    .padding()
  }
}
