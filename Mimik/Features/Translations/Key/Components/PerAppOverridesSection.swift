//
//  PerAppOverridesSection.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 29/10/26.
//
//  Lets a key's shared, per-language translation be overridden for one app
//  at a time - e.g. the same logical string needs a different formatted-
//  string placeholder syntax on Android vs iOS. Closure-driven rather than
//  bound to EditTranslationsViewModel directly, matching AppInclusionPicker.

import SwiftUI

struct PerAppOverridesSection: View {
  let includedApps: [WSAppDTO]
  let langs: [WSLangDTO]
  let defaultLang: String
  let defaultValue: (_ lang: String) -> String
  let overrideValue: (_ appId: UUID, _ lang: String) -> String?
  let hasAnyOverride: (_ appId: UUID) -> Bool
  let onStartCustomizing: (_ appId: UUID, _ lang: String) -> Void
  let onChange: (_ appId: UUID, _ lang: String, _ value: String) -> Void
  let onReset: (_ appId: UUID, _ lang: String) -> Void

  var body: some View {
    if !includedApps.isEmpty && !langs.isEmpty {
      VStack(alignment: .leading, spacing: 10) {
        Text("Customize per app")
          .font(.subheadline.weight(.semibold))
          .foregroundColor(.secondary)

        Text("Falls back to the values above unless overridden - useful when a formatted string needs different placeholder syntax per platform.")
          .font(.caption2)
          .foregroundColor(.secondary.opacity(0.8))

        ForEach(includedApps) { app in
          AppOverrideDisclosure(
            app: app,
            langs: langs,
            defaultLang: defaultLang,
            defaultValue: defaultValue,
            overrideValue: { lang in overrideValue(app.id, lang) },
            hasAnyOverride: hasAnyOverride(app.id),
            onStartCustomizing: { lang in onStartCustomizing(app.id, lang) },
            onChange: { lang, value in onChange(app.id, lang, value) },
            onReset: { lang in onReset(app.id, lang) }
          )
        }
      }
    }
  }
}

private struct AppOverrideDisclosure: View {
  let app: WSAppDTO
  let langs: [WSLangDTO]
  let defaultLang: String
  let defaultValue: (String) -> String
  let overrideValue: (String) -> String?
  let hasAnyOverride: Bool
  let onStartCustomizing: (String) -> Void
  let onChange: (String, String) -> Void
  let onReset: (String) -> Void

  @State private var isExpanded = false

  var body: some View {
    DisclosureGroup(isExpanded: $isExpanded) {
      VStack(alignment: .leading, spacing: 10) {
        ForEach(langs) { lang in
          languageRow(lang: lang)
        }
      }
      .padding(.top, 8)
    } label: {
      HStack(spacing: 8) {
        Image(SupportedPlatforms.getImage(for: app.appPlatformId))
          .resizable()
          .scaledToFit()
          .frame(width: 16, height: 16)

        Text(app.name)
          .font(.subheadline.weight(.medium))

        if hasAnyOverride {
          Text("Customized")
            .font(.caption2.weight(.semibold))
            .foregroundColor(AppColors.primaryStart)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(AppColors.primaryStart.opacity(0.12)))
        }
      }
    }
    .padding(12)
    .background(RoundedRectangle(cornerRadius: 12).fill(.white))
    .overlay(
      RoundedRectangle(cornerRadius: 12)
        .stroke(AppColors.cardBorder, lineWidth: 1)
    )
  }

  @ViewBuilder
  private func languageRow(lang: WSLangDTO) -> some View {
    let override = overrideValue(lang.code)
    let label = lang.code == defaultLang ? "\(lang.name) (Default)" : lang.name

    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text(label)
          .font(.caption.weight(.medium))
          .foregroundColor(.secondary)

        Spacer()

        if override != nil {
          Button("Reset to default") { onReset(lang.code) }
            .buttonStyle(.plain)
            .font(.caption2.weight(.medium))
            .foregroundStyle(AppColors.primaryStart)
        } else {
          Button("Customize") { onStartCustomizing(lang.code) }
            .buttonStyle(.plain)
            .font(.caption2.weight(.medium))
            .foregroundStyle(AppColors.primaryStart)
        }
      }

      if let override {
        AppTextEditor(
          label: "",
          value: Binding(
            get: { override },
            set: { onChange(lang.code, $0) }
          ),
          error: .constant(nil),
          height: 56
        )
      } else {
        let fallback = defaultValue(lang.code)
        Text(fallback.isEmpty ? "No default value yet" : fallback)
          .font(.body)
          .foregroundColor(.secondary)
          .italic(fallback.isEmpty)
          .lineLimit(2)
          .truncationMode(.tail)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal, 4)
          .padding(.vertical, 6)
      }
    }
  }
}

#Preview {
  PerAppOverridesSection(
    includedApps: [
      WSAppDTO(
        id: UUID(),
        name: "Driver App",
        desc: "",
        workspaceId: UUID(),
        appPlatformId: SupportedPlatforms.ANDROID.id,
        createdAt: Date(),
        updatedAt: Date(),
        lastAccessed: Date()
      )
    ],
    langs: [
      WSLangDTO(id: UUID(), workspaceId: UUID(), code: "en", name: "English", rtl: false, author: "", active: true, createdAt: Date(), updatedAt: Date())
    ],
    defaultLang: "en",
    defaultValue: { _ in "You have %1$d new orders" },
    overrideValue: { _, _ in nil },
    hasAnyOverride: { _ in false },
    onStartCustomizing: { _, _ in },
    onChange: { _, _, _ in },
    onReset: { _, _ in }
  )
  .padding()
  .background(AppColors.canvasBackground)
}
