//
//  NestedTranslationsView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 03/12/25.
//
import SwiftUI

struct NestedTree: View {
  let level: Int
  let allGroups: [TranslationGroupDTO]
  let group: TranslationGroupDTO
  let onAddGroup: (UUID) -> Void
  
  @State private var isExpanded: Bool = false

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      DisclosureGroup(isExpanded: $isExpanded) {
        VStack {
          ForEach(allGroups.filter { $0.parentGroupId == group.id }) { g in
            NestedTree(
              level: level + 1,
              allGroups: allGroups,
              group: g,
              onAddGroup: onAddGroup
            )
          }
        }
        .padding(4.0)
      } label: {
        HStack {
          Text(group.key)
            .font(.title3)
          Spacer()
          Button("Add Translation") {
            onAddGroup(group.id)
          }
          .buttonStyle(.bordered)
          .tint(.green)
          .padding(.vertical, 5)
          Button("Add Group") {
            onAddGroup(group.id)
          }
          .buttonStyle(.bordered)
          .tint(.blue)
          .padding(.vertical, 5)
        }
        .padding(.leading, 8)
      }
    }
    .padding(8)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(level % 2 == 0 ? Color.white : Color.gray.opacity(0.1))
        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
    )
    .padding(.leading, CGFloat(level * 8))
  }
}
