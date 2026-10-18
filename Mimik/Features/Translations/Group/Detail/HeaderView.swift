//
//  HeaderView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 03/09/26.
//
import SwiftUI
import Factory

struct GradientPillButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.subheadline.weight(.semibold))
      .foregroundColor(.white)
      .padding(.horizontal, 18)
      .padding(.vertical, 10)
      .background(AppColors.primaryGradient)
      .clipShape(Capsule())
      .shadow(
        color: AppColors.primaryStart.opacity(0.35),
        radius: configuration.isPressed ? 2 : 6,
        y: configuration.isPressed ? 1 : 3
      )
      .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
      .opacity(configuration.isPressed ? 0.9 : 1.0)
  }
}

struct GhostButtonStyle: ButtonStyle {
  var color: Color

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.subheadline.weight(.medium))
      .foregroundColor(color)
      .padding(.horizontal, 14)
      .padding(.vertical, 9)
      .background(
        Capsule().fill(color.opacity(configuration.isPressed ? 0.16 : 0.08))
      )
      .opacity(configuration.isPressed ? 0.85 : 1.0)
  }
}

struct GroupBreadcrumb : View {

  let group: TranslationGroupDTO
  let parentGroups: [BreadcrumbItem]
  var onAddGroup: () -> Void = {}
  var onAddKey: () -> Void = {}
  var onBreadcrumbTap: (String) -> Void = { _ in }

  var body: some View {
    HStack(alignment: .top) {
      headerLeftSection()
      Spacer()
      headerRightSection()
    }
    .padding(.all, 20)
    .background(
      Rectangle()
        .fill(.white)
        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
    )
  }

  func headerRightSection() -> some View {
    return HStack(spacing: 10) {
      Button(action: {}) {
        Label("Rename", systemImage: "pencil")
      }
      .buttonStyle(GhostButtonStyle(color: .black.opacity(0.65)))

      Button(action: {}) {
        Label("Delete", systemImage: "trash")
      }
      .buttonStyle(GhostButtonStyle(color: AppColors.danger))

      Button(action: onAddGroup) {
        Label("Add Group", systemImage: "folder.badge.plus")
      }
      .buttonStyle(GradientPillButtonStyle())

      Button(action: onAddKey) {
        Label("Add Key", systemImage: "plus.circle.fill")
      }
      .buttonStyle(GradientPillButtonStyle())
    }
  }

  func headerLeftSection() -> VStack<TupleView<(Text, Breadcrumb)>> {
    return VStack(alignment: .leading, spacing: 6) {
      Text(
        group.displayLabel,
      )
      .font(.title2)
      .bold()

      Breadcrumb(
        items: parentGroups + [
          BreadcrumbItem(
            id: group.id.uuidString,
            label: group.displayLabel
          )
        ],
        onTap: onBreadcrumbTap
      )
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
