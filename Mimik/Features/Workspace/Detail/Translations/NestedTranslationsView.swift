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
//  key: n7, workspaceId: 49C32806-C68C-4459-80A7-14FFABFB5DB1, parentGroupId: Optional(744C4D3F-9C10-4A8E-B457-5D310ECFA2A0)

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
//            onAddGroup(group.id)
          }
          .buttonStyle(.bordered)
          .tint(.green)
          .padding(.vertical, 5)
          Button("Add Group") {
            print("adding on level: \(level), with group id: \(group.id)")
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
