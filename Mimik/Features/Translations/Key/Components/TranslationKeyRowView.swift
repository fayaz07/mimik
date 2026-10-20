//
//  TranslationKeyRowView.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import SwiftUI
import AppKit

struct TranslationKeyRowView: View {
  let item: KeyListItem
  var onEdit: (TranslationKeyDTO) -> Void = { _ in }

  @State private var isCopied = false

  private var hasTranslation: Bool {
    !(item.defaultLangValue ?? "").isEmpty
  }

  private var progress: Double {
    item.totalLanguages > 0
      ? Double(item.translatedCount) / Double(item.totalLanguages)
      : 0
  }

  private var accentColor: Color {
    if item.isFullyTranslated { return AppColors.success }
    if item.translatedCount > 0 { return AppColors.warning }
    return AppColors.danger
  }

  var body: some View {
    HStack(spacing: 0) {
      RoundedRectangle(cornerRadius: 2)
        .fill(accentColor)
        .frame(width: 4)

      HStack(spacing: 14) {
        VStack(alignment: .leading, spacing: 3) {
          HStack(spacing: 5) {
            Text(item.key.key)
              .font(.caption)
              .foregroundColor(.secondary)
              .lineLimit(1)
              .truncationMode(.tail)
              .help(item.key.key)

            Button(action: copyKey) {
              Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                .font(.system(size: 10))
                .foregroundStyle(isCopied ? AppColors.success : Color.secondary)
            }
            .buttonStyle(.plain)
            .help("Copy key")
          }

          if hasTranslation {
            Text(item.defaultLangValue ?? "")
              .font(.body.weight(.medium))
              .foregroundStyle(.black)
              .lineLimit(1)
              .truncationMode(.tail)
              .help(item.defaultLangValue ?? "")
          } else {
            Text("Not translated yet")
              .font(.body.italic())
              .foregroundColor(.secondary)
              .lineLimit(1)
          }
        }

        Spacer()

        VStack(alignment: .trailing, spacing: 4) {
          Text("\(item.translatedCount)/\(item.totalLanguages)")
            .font(.caption.weight(.semibold))
            .foregroundColor(.secondary)
          Text("languages")
            .font(.system(size: 10))
            .foregroundColor(.secondary.opacity(0.7))
        }

        ProgressRingView(progress: progress)
          .frame(width: 30, height: 30)

        Button(action: { onEdit(item.key) }) {
          Image(systemName: "pencil")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: 28, height: 28)
            .background(AppColors.primaryGradient)
            .clipShape(Circle())
        }
        .buttonStyle(PlainButtonStyle())
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
    }
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(.white)
    )
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(AppColors.cardBorder, lineWidth: 1)
    )
    .shadow(color: .black.opacity(0.03), radius: 3, y: 2)
    .clipShape(RoundedRectangle(cornerRadius: 12))
  }

  private func copyKey() {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(item.key.key, forType: .string)

    isCopied = true
    Task {
      try? await Task.sleep(for: .seconds(1.2))
      await MainActor.run { isCopied = false }
    }
  }
}

#Preview {
  VStack(spacing: 8) {
    TranslationKeyRowView(
      item: KeyListItem(
        key: TranslationKeyDTO(
          id: UUID(),
          key: "login.button.title",
          author: "{}",
          workspaceId: UUID(),
          groupId: UUID(),
          createdAt: Date(),
          updatedAt: Date()
        ),
        defaultLangValue: "Log in",
        translatedCount: 3,
        totalLanguages: 5
      )
    )

    TranslationKeyRowView(
      item: KeyListItem(
        key: TranslationKeyDTO(
          id: UUID(),
          key: "login.error.invalid_credentials",
          author: "{}",
          workspaceId: UUID(),
          groupId: UUID(),
          createdAt: Date(),
          updatedAt: Date()
        ),
        defaultLangValue: nil,
        translatedCount: 0,
        totalLanguages: 5
      )
    )

    TranslationKeyRowView(
      item: KeyListItem(
        key: TranslationKeyDTO(
          id: UUID(),
          key: "common.done",
          author: "{}",
          workspaceId: UUID(),
          groupId: UUID(),
          createdAt: Date(),
          updatedAt: Date()
        ),
        defaultLangValue: "Done",
        translatedCount: 5,
        totalLanguages: 5
      )
    )
  }
  .padding()
  .background(Color.gray.opacity(0.1))
}
