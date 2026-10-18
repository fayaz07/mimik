import SwiftUI

/// BreadcrumbItem - Represents a breadcrumb navigation item
/// - Parameters:
///   - id: Unique identifier for navigation
///   - label: Display text for the breadcrumb
///   - icon: Optional SF Symbol name
public struct BreadcrumbItem: Hashable {
  public let id: String
  public let label: String
  public let icon: String?

  /// Create a breadcrumb item with id, label, and optional icon
  init(id: String, label: String, icon: String? = nil) {
    self.id = id
    self.label = label
    self.icon = icon
  }
}

/// BreadcrumbItemView - A single clickable breadcrumb item view
/// - Parameters:
///   - id: Unique identifier for navigation
///   - label: Display text for the breadcrumb
///   - icon: Optional SF Symbol name
///   - isCurrent: true for the last/current item - rendered as plain text,
///     not clickable, since you're already there
struct BreadcrumbItemView: View {
  let id: String
  let label: String
  var icon: String?
  var isCurrent: Bool = false
  var onTap: (String) -> Void = { _ in }

  @State private var isHovered = false

  var body: some View {
    Button(action: { onTap(id) }) {
      HStack(spacing: 8) {
        if let icon = icon {
          Image(systemName: icon)
            .font(.caption)
            .foregroundStyle(
              isCurrent
                ? Color.primary
                : (isHovered ? AppColors.primaryStart : Color.secondary.opacity(0.7))
            )
        }

        Text(label)
          .font(isCurrent ? .body.weight(.semibold) : .body)
          .foregroundStyle(
            isCurrent
              ? Color.primary
              : (isHovered ? AppColors.primaryStart : Color.secondary)
          )
          .lineLimit(1)
          .truncationMode(.tail)
      }
      .frame(alignment: .leading)
    }
    .buttonStyle(.plain)
    .disabled(isCurrent)
    .onHover { isHovered = $0 }
    .help(label)
  }
}

/// Breadcrumb - The full breadcrumb navigation component
/// - Parameters:
///   - items: Array of BreadcrumbItem instances, oldest ancestor first
///   - onTap: called with the tapped item's id - the last item is treated
///     as the current page and isn't tappable
struct Breadcrumb: View {
  let items: [BreadcrumbItem]
  var onTap: (String) -> Void = { _ in }

  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    HStack(spacing: 0) {
      ForEach(items, id: \.id) { item in
        BreadcrumbItemView(
          id: item.id,
          label: item.label,
          icon: item.icon,
          isCurrent: items.last?.id == item.id,
          onTap: onTap
        )

        // Add chevron separator if not the last item
        if items.last?.id != item.id {
          Text("›")
            .font(.title2)
            .foregroundStyle(Color.secondary.opacity(0.5))
            .padding(.leading, 8)
            .padding(.trailing, 8)
        }
      }
    }
    .background(Color(.white))
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

#Preview {
  Breadcrumb(
    items: [
      BreadcrumbItem(id: "home", label: "Home", icon: "house"),
      BreadcrumbItem(
        id: "dashboard",
        label: "Dashboard",
        icon: "chart.bar.fill"
      ),
      BreadcrumbItem(id: "analytics", label: "Analytics", icon: nil)
    ]
  )

  Breadcrumb(
    items: [
      BreadcrumbItem(id: "home", label: "Home"),
      BreadcrumbItem(
        id: "dashboard",
        label: "Dashboard",
      ),
      BreadcrumbItem(id: "analytics", label: "Analytics")
    ]
  )
}
