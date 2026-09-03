//
//  HeaderView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 03/09/26.
//
import SwiftUI
import Factory

struct GroupBreadcrumb : View {
  
  let group: TranslationGroupDTO
  let parentGroups: [BreadcrumbItem]
  
  var body: some View {
    HStack {
      headerLeftSection()
      Spacer()
      headerRightSection()
    }
    .padding(.all, 16)
  }
  
  struct CustomBorderButtonStyle: ButtonStyle {
    var color: Color
    
    func makeBody(configuration: Configuration) -> some View {
      configuration.label
        .padding(.horizontal, 24)
        .padding(.vertical, 10)
        .foregroundColor(color)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .fill(configuration.isPressed ? color.opacity(0.15) : Color.clear)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(color, lineWidth: 0.35)
        )
        .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
  }
  
  func headerRightSection() -> some View {
    return VStack {
      HStack {
        Button(action: {}, label: {Text("Rename")})
          .buttonStyle(CustomBorderButtonStyle(color: .black))
        Button(
          action: {},
          label: {
            Text("Delete")
          }
        ).buttonStyle(CustomBorderButtonStyle(color: .red))
        
        Button(action: {}, label: {Text("+ Add key")})
          .buttonStyle(CustomBorderButtonStyle(color: .black))
      }
      Spacer()
    }
  }
  
  func headerLeftSection() -> VStack<TupleView<(Text, Breadcrumb, Spacer)>> {
    return VStack(alignment: .leading, spacing: 0) {
      Text(
        group.key,
      )
      .font(.title2)
      .bold()
      
      Breadcrumb(
        items: parentGroups + [
          BreadcrumbItem(
            id: group.id.uuidString,
            label: group.key
          )
        ]
      )
      Spacer()
    }
  }
}

#Preview {
  GroupBreadcrumb(
    group: TranslationGroupDTO(
      id: UUID(),
      workspaceId: UUID(),
      key: "general-group",
      parentGroupId: nil,
      createdAt: Date(),
      updatedAt: Date()
    ),
    parentGroups: [
      BreadcrumbItem(id: "home-id", label: "Home", icon: "house"),
      //      BreadcrumbItem(id: "locales-id", label: "Locales", icon: "globe"),
      //      BreadcrumbItem(id: "auth-id", label: "Authentication", icon: "folder")
    ]
  )
}
