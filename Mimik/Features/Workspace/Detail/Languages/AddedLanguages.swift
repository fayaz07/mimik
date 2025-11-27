//
//  AddedLanguages.swift
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
  GridItem(.flexible(minimum: 40), alignment: .leading),
  GridItem(.flexible(minimum: 40), alignment: .center)
]

struct AddedLanguages: View {
  let data: [String: WSLangDTO]
  
  var body: some View {
    let list = Array(data.values)
    
    if list.isEmpty {
      VStack {
        Text("No languages added yet. Start by adding a language!")
      }
    } else {
      VStack(spacing: 0) {
        // Header
        LazyVGrid(columns: _columns, spacing: 0) {
          Text("#").bold().padding(.vertical, 5)
          Text("Code").bold().padding(.vertical, 5)
          Text("Name").bold().padding(.vertical, 5)
          Text("Direction").bold().padding(.vertical, 5)
          Text("Author").bold().padding(.vertical, 5)
          Text("Actions").bold().padding(.vertical, 5)
        }
        Divider()
        
        // Rows
        ForEach(0..<list.count, id: \.self) { index in
          langRow(index: index, item: list[index])
        }
      }
      .padding()
    }
  }

  func langRow(index: Int, item: WSLangDTO) -> some View {
    return LazyVGrid(columns: _columns, spacing: 0) {
      Text("\(index + 1)").padding(.vertical, 5)
      Text(item.code).padding(.vertical, 5)
      Text(item.name).padding(.vertical, 5)
      Text(item.rtl ? "Right to Left" : "Left to Right")
        .padding(.vertical, 5)
      Text(ParseAuthorDTO(from: item.author).name)
        .padding(.vertical, 5)
      
      Button(item.active ? "Disable" : "Enable") { }
        .buttonStyle(.bordered)
        .tint(item.active ? .red : .green)
        .padding(.vertical, 5)
    }
    .background(index.isMultiple(of: 2)
                ? Color.white
                : Color.gray.opacity(0.06))   // full-row background
  }
}
