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

  var body: some View {
    let loading = viewModel.saveResult.loading

    return ZStack {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {

        // Inline, not .toolbar - see the same change (and why) on
        // TrslnGroupDetailView: this screen isn't pushed onto its own
        // NavigationStack anymore, so a .toolbar here could collide with
        // whatever ancestor actually hosts one.
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

        Breadcrumb(
          items: parentGroups + [
            BreadcrumbItem(id: "group", label: groupName),
            BreadcrumbItem(id: currentKey.id.uuidString, label: currentKey.key)
          ]
        )
        .padding(.horizontal, 16)

        appsSection

        languagesSection

        if viewModel.saveResult.hasError {
          Text(
            viewModel.saveResult.error ?? "Something went wrong. Please try again."
          )
          .foregroundColor(.red)
          .multilineTextAlignment(.leading)
          .lineLimit(nil)
          .fixedSize(horizontal: false, vertical: true)
          .padding(.horizontal, 16)
        }

        HStack {
          Spacer()

          Button("Cancel") { nav.pop() }
            .disabled(loading)

          Button(action: {
            viewModel.save(keyId: currentKey.id)
          }) {
            if loading {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            } else {
              Text("Save")
            }
          }
          .disabled(loading)
          .keyboardShortcut(.defaultAction)
        }
        .padding(.horizontal, 16)
      }
      .padding(.vertical, 16)
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
}

#Preview {
  //  EditTranslationsScreen()
}
