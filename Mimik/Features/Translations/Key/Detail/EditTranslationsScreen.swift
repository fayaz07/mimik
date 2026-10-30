//
//  EditTranslationsScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import SwiftUI
import Factory

struct EditTranslationsScreen: View {

  /// Held in @State, resolved once in init - not @Injected. See the same
  /// fix (and its full reasoning) on TrslnGroupDetailView: @Injected's
  /// default scope re-resolves a fresh instance on every re-render, which
  /// orphans an in-flight load() Task and leaves the screen permanently
  /// stuck on its loading state.
  @State private var viewModel: EditTranslationsViewModel

  /// Local to the Translations tab - see TranslationsNavigator.
  @Environment(TranslationsNavigator.self) var nav: TranslationsNavigator

  let workspaceId: UUID
  let groupName: String
  let parentGroups: [BreadcrumbItem]


  /// Held in @State, not `let` - toggling which apps this key is excluded
  /// from updates this in place so the picker reflects the change right
  /// away, the same way TrslnGroupDetailView handles a group rename.
  @State private var currentKey: TranslationKeyDTO

  @State private var showSavedToast = false
  @State private var isUpdatingApps = false
  @State private var appsError: String?

  @Injected(\.updateKeyExcludedAppsUsecase) private var updateExcludedAppsUsecase: UpdateKeyExcludedAppsUsecase

  init(workspaceId: UUID, key: TranslationKeyDTO, groupName: String, parentGroups: [BreadcrumbItem]) {
    self.workspaceId = workspaceId
    self._currentKey = State(wrappedValue: key)
    self.groupName = groupName
    self.parentGroups = parentGroups
    self._viewModel = State(wrappedValue: Container.shared.editTranslationsViewModel.resolve())
  }

  private func binding(for code: String) -> Binding<String> {
    Binding(
      get: { viewModel.value(for: code) },
      set: { viewModel.setValue($0, for: code) }
    )
  }

  private var loading: Bool {
    viewModel.saveResult.loading
  }

  var body: some View {
    ZStack {
      VStack(spacing: 0) {
        headerBar

        if viewModel.saveResult.hasError {
          Text(
            viewModel.saveResult.error ?? "Something went wrong. Please try again."
          )
          .foregroundColor(.red)
          .font(.caption)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.horizontal, 16)
          .padding(.top, 10)
        }

        ScrollView {
          VStack(alignment: .leading, spacing: 16) {
            Breadcrumb(
              items: parentGroups + [
                BreadcrumbItem(id: "group", label: groupName),
                BreadcrumbItem(id: currentKey.id.uuidString, label: currentKey.key)
              ]
            )
            .padding(.horizontal, 16)
            .padding(.top, 16)

            appsSection

            languagesSection

            overridesSection
          }
          .padding(.bottom, 16)
        }
      }
      .background(.white)
      .navigationTitle("Edit Translations")
      .onAppear {
        viewModel.load(workspaceId: workspaceId, keyId: currentKey.id)
      }
      .onReceive(viewModel.$saveEvent) { event in
        switch event.data {
          case .saved:
            showSavedToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
              nav.pop()
            }
          default:
            break
        }
      }

      Snackbar(text: "Translations saved", show: showSavedToast)
    }
  }

  /// Fixed, not inside the ScrollView - Save/Cancel (and Back) need to stay
  /// reachable regardless of how long this screen gets, especially now that
  /// per-app overrides can add a lot of extra height below the fold.
  /// Not .toolbar, for the same reason as before: this screen isn't pushed
  /// onto its own NavigationStack, so a .toolbar here could collide with
  /// whatever ancestor actually hosts one.
  private var headerBar: some View {
    HStack {
      Button(action: { nav.pop() }) {
        HStack(spacing: 4) {
          Image(systemName: "chevron.left")
          Text("Back")
        }
        .font(.subheadline.weight(.medium))
        .foregroundStyle(AppColors.primaryStart)
      }
      .buttonStyle(.plain)
      .disabled(loading)

      Spacer()

      Button("Cancel") { nav.pop() }
        .buttonStyle(GhostButtonStyle(color: .secondary))
        .disabled(loading)

      Button(action: {
        viewModel.save(keyId: currentKey.id)
      }) {
        if loading {
          ProgressView()
            .controlSize(.small)
        } else {
          Text("Save")
        }
      }
      .buttonStyle(GradientPillButtonStyle())
      .disabled(loading)
      .keyboardShortcut(.defaultAction)
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(
      Rectangle()
        .fill(.white)
        .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
    )
  }

  var appsSection: some View {
    ViewStateUIBuilder(
      state: viewModel.workspaceApps) {
        EmptyView()
      } forError: { _ in
        EmptyView()
      } forData: { apps in
        VStack(alignment: .leading, spacing: 6) {
          if !apps.isEmpty {
            Text("Included in")
              .font(.subheadline.weight(.semibold))
              .foregroundColor(.secondary)

            AppInclusionPicker(
              apps: apps,
              excludedAppIds: Set(currentKey.excludedApps),
              isDisabled: isUpdatingApps,
              onToggle: toggleApp
            )

            if let appsError {
              Text(appsError)
                .font(.caption2)
                .foregroundColor(AppColors.danger)
            }
          }
        }
        .padding(.horizontal, 16)
      } forNoData: {
        EmptyView()
      }
  }

  private func toggleApp(_ app: WSAppDTO) {
    var excluded = Set(currentKey.excludedApps)
    if excluded.contains(app.id) {
      excluded.remove(app.id)
    } else {
      excluded.insert(app.id)
    }

    isUpdatingApps = true
    appsError = nil
    Task {
      do {
        let updated = try await updateExcludedAppsUsecase.update(
          keyId: currentKey.id,
          excludedApps: Array(excluded)
        )
        await MainActor.run {
          isUpdatingApps = false
          currentKey = updated
        }
      } catch {
        await MainActor.run {
          isUpdatingApps = false
          appsError = "Couldn't update. Try again."
        }
      }
    }
  }

  var languagesSection: some View {
    ViewStateUIBuilder(
      state: viewModel.languages) {
        ProgressView()
          .padding(.horizontal, 16)
      } forError: { error in
        Text(error)
          .foregroundColor(.red)
          .padding(.horizontal, 16)
      } forData: { langs in
        VStack(alignment: .leading, spacing: 16) {
          ForEach(langs) { lang in
            AppTextEditor(
              label: lang.code == viewModel.defaultLang
                ? "\(lang.name) (Default)"
                : lang.name,
              value: binding(for: lang.code),
              error: .constant(nil),
              height: 80
            )
          }
        }
        .padding(.horizontal, 16)
      } forNoData: {
        Text("No active languages. Add some from the Languages tab first.")
          .foregroundColor(.secondary)
          .padding(.horizontal, 16)
      }
  }

  /// Apps this key is still included in, excluding the ones toggled off in
  /// appsSection above - overriding a value for an app that's excluded
  /// from this key entirely wouldn't mean anything.
  private var includedApps: [WSAppDTO] {
    (viewModel.workspaceApps.data ?? []).filter { !currentKey.excludedApps.contains($0.id) }
  }

  var overridesSection: some View {
    Group {
      if let langs = viewModel.languages.data, !langs.isEmpty {
        PerAppOverridesSection(
          includedApps: includedApps,
          langs: langs,
          defaultLang: viewModel.defaultLang,
          defaultValue: { code in viewModel.value(for: code) },
          overrideValue: { appId, code in viewModel.overrideValue(appId: appId, lang: code) },
          hasAnyOverride: { appId in viewModel.hasAnyOverride(appId: appId) },
          onStartCustomizing: { appId, code in viewModel.startCustomizing(appId: appId, lang: code) },
          onChange: { appId, code, value in viewModel.setOverrideValue(value, appId: appId, lang: code) },
          onReset: { appId, code in viewModel.resetToDefault(appId: appId, lang: code) }
        )
        .padding(.horizontal, 16)
      }
    }
  }
}

#Preview {
  //  EditTranslationsScreen()
}
