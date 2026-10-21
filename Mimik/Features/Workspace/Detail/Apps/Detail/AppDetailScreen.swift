//
//  AppDetailScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 20/10/26.
//

import SwiftUI
import Factory
import AppKit

struct AppDetailScreen: View {
  let app: WSAppDTO

  /// Local to the Apps tab, not the app-wide router - see AppsNavigator for
  /// why (keeps the workspace sidebar visible instead of this screen
  /// replacing the whole WorkspaceDetailScreen).
  @Environment(AppsNavigator.self) var nav: AppsNavigator

  /// Held in @State, resolved once in init - not @Injected. See the same
  /// fix (and its full reasoning) on TrslnGroupDetailView/EditTranslations-
  /// Screen: @Injected's default scope re-resolves a fresh instance on
  /// every re-render, which would orphan an in-flight load() Task.
  @State private var viewModel: AppDetailViewModel

  /// The export action is a one-off, not state this screen needs to keep
  /// around, so it's called directly from here rather than through the
  /// ViewModel - the same pattern GroupBreadcrumb uses for rename/delete.
  @Injected(\.exportAppTranslationsUsecase) private var exportUsecase: ExportAppTranslationsUsecase

  @State private var selectedLang: String = ""
  @State private var selectedFormat: TranslationExportFormat = .xml
  @State private var isExporting = false
  @State private var exportError: String?
  @State private var showExportedToast = false

  init(app: WSAppDTO) {
    self.app = app
    self._viewModel = State(wrappedValue: Container.shared.appDetailViewModel.resolve())
  }

  private var isAndroid: Bool {
    app.appPlatformId == SupportedPlatforms.ANDROID.id
  }

  private func langBinding() -> Binding<String> {
    Binding(
      get: { selectedLang.isEmpty ? viewModel.defaultLang : selectedLang },
      set: { selectedLang = $0 }
    )
  }

  var body: some View {
    ZStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          // Inline, not .toolbar - see the same change (and why) on
          // AddAppScreen: this screen isn't pushed onto its own
          // NavigationStack, so a .toolbar here could collide with
          // WorkspaceDetailScreen's own toolbar.
          Button(action: { nav.pop() }) {
            HStack(spacing: 4) {
              Image(systemName: "chevron.left")
              Text("Back")
            }
            .font(.subheadline.weight(.medium))
            .foregroundStyle(AppColors.primaryStart)
          }
          .buttonStyle(.plain)
          .padding(.horizontal, 16)
          .padding(.top, 12)
          .padding(.bottom, 4)

          appInfoSection
            .padding(.horizontal, 16)

          exportSection
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 24)
      }
      .background(AppColors.canvasBackground)

      Snackbar(text: "Exported successfully", show: showExportedToast)
    }
    .navigationTitle(app.name)
    .onAppear {
      viewModel.load(workspaceId: app.workspaceId)
    }
  }

  private var appInfoSection: some View {
    HStack(alignment: .top, spacing: 16) {
      Image(SupportedPlatforms.getImage(for: app.appPlatformId))
        .resizable()
        .scaledToFit()
        .frame(width: 44, height: 44)

      VStack(alignment: .leading, spacing: 6) {
        Text(app.name)
          .font(.title2)
          .bold()

        Text(app.desc)
          .font(.subheadline)
          .foregroundColor(.secondary)

        HStack(spacing: 6) {
          Text("Created \(customRelativeTimeString(from: app.createdAt))")
          Text("·")
          Text("Last accessed \(customRelativeTimeString(from: app.lastAccessed))")
        }
        .font(.caption)
        .foregroundColor(.secondary.opacity(0.8))
      }

      Spacer()
    }
    .padding(16)
    .background(RoundedRectangle(cornerRadius: 16).fill(.white))
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(AppColors.cardBorder, lineWidth: 1)
    )
  }

  private var exportSection: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text("Export Translations")
        .font(.headline)

      if !isAndroid {
        Text("Export isn't available yet for this platform.")
          .font(.subheadline)
          .foregroundColor(.secondary)
      } else {
        ViewStateUIBuilder(
          state: viewModel.languages) {
            ProgressView()
          } forError: { error in
            Text(error)
              .foregroundColor(.red)
          } forData: { langs in
            return exportControls(langs: langs)
          } forNoData: {
            EmptyView()
          }
      }
    }
    .padding(16)
    .background(RoundedRectangle(cornerRadius: 16).fill(.white))
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(AppColors.cardBorder, lineWidth: 1)
    )
  }

  @ViewBuilder
  private func exportControls(langs: [WSLangDTO]) -> some View {
    if langs.isEmpty {
      Text("No active languages. Add some from the Languages tab first.")
        .foregroundColor(.secondary)
    } else {
      VStack(alignment: .leading, spacing: 14) {
        HStack(alignment: .top, spacing: 24) {
          VStack(alignment: .leading, spacing: 6) {
            Text("Language")
              .font(.caption.weight(.medium))
              .foregroundColor(.secondary)

            Picker(selection: langBinding()) {
              ForEach(langs) { lang in
                Text(lang.code == viewModel.defaultLang ? "\(lang.name) (Default)" : lang.name)
                  .tag(lang.code)
              }
            } label: {
              EmptyView()
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .fixedSize()
          }

          VStack(alignment: .leading, spacing: 6) {
            Text("Format")
              .font(.caption.weight(.medium))
              .foregroundColor(.secondary)

            Picker(selection: $selectedFormat) {
              ForEach(TranslationExportFormat.allCases) { format in
                Text(format.label).tag(format)
              }
            } label: {
              EmptyView()
            }
            .labelsHidden()
            .pickerStyle(.segmented)
            .frame(width: 140)
          }
        }

        Button(action: exportTranslations) {
          HStack {
            if isExporting {
              ProgressView()
                .controlSize(.small)
                .tint(.white)
            } else {
              Label("Export", systemImage: "square.and.arrow.up")
            }
          }
        }
        .buttonStyle(GradientPillButtonStyle())
        .disabled(isExporting)

        if let exportError {
          Text(exportError)
            .font(.caption)
            .foregroundColor(AppColors.danger)
        }
      }
    }
  }

  private func exportTranslations() {
    let lang = selectedLang.isEmpty ? viewModel.defaultLang : selectedLang
    guard !lang.isEmpty else { return }

    isExporting = true
    exportError = nil
    Task {
      do {
        let content = try await exportUsecase.export(
          workspaceId: app.workspaceId,
          appId: app.id,
          lang: lang,
          format: selectedFormat
        )
        await MainActor.run {
          isExporting = false
          saveToFile(content: content, format: selectedFormat)
        }
      } catch {
        await MainActor.run {
          isExporting = false
          exportError = "Couldn't generate the export. Please try again."
        }
      }
    }
  }

  /// `.begin(completionHandler:)`, not the blocking `.runModal()` - runModal()
  /// spins its own nested run loop, which doesn't play well with being
  /// called from code that got here via a Swift Concurrency Task (even
  /// after hopping back to the main actor), and was the source of the
  /// runtime crash here. `.begin` is the non-blocking, async-friendly way
  /// to show a save panel and is safe to call from any main-actor context.
  private func saveToFile(content: String, format: TranslationExportFormat) {
    let panel = NSSavePanel()
    panel.nameFieldStringValue = format.suggestedFileName
    panel.canCreateDirectories = true

    panel.begin { response in
      guard response == .OK, let url = panel.url else { return }
      do {
        try content.write(to: url, atomically: true, encoding: .utf8)
        showExportedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
          showExportedToast = false
        }
      } catch {
        exportError = "Couldn't save the file. Please try again."
      }
    }
  }
}
