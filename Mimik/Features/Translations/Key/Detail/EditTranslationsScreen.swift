//
//  EditTranslationsScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 17/10/26.
//

import SwiftUI
import Factory

struct EditTranslationsScreen: View {

  @Injected(\.editTranslationsViewModel)
  var viewModel: EditTranslationsViewModel

  @EnvironmentObject var router: AppNavigationRouter

  let workspaceId: UUID
  let key: TranslationKeyDTO
  let groupName: String
  let parentGroups: [BreadcrumbItem]

  @State private var showSavedToast = false

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

        Breadcrumb(
          items: parentGroups + [
            BreadcrumbItem(id: "group", label: groupName),
            BreadcrumbItem(id: key.id.uuidString, label: key.key)
          ]
        )

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

          Button("Cancel") { router.pop() }
            .disabled(loading)

          Button(action: {
            viewModel.save(keyId: key.id)
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
    .toolbar {
      BackNavButton {
        router.pop()
      }
    }
    .onAppear {
      viewModel.load(workspaceId: workspaceId, keyId: key.id)
    }
    .onReceive(viewModel.$saveEvent) { event in
      switch event.data {
        case .saved:
          showSavedToast = true
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            router.pop()
          }
        default:
          break
      }
    }

      Snackbar(text: "Translations saved", show: showSavedToast)
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
