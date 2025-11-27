//
//  WorkspaceLanguagesScreen.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 14/10/25.
//

import SwiftUI
import CoreData
import Factory

struct WSLanguagesScreen: View {
  var data: WorkspaceDTO
  
  @Injected(\.workspaceLanguagesViewModel)
  private var viewModel: WSLanguagesViewModel
  
  var body: some View {
    List {
      Section(
        header: Text("Added Languages").font(.headline)
      ) {
        addedlangs
      }
      
      Section(
        header: Text("Available Languages").font(.headline)
      ) {
        availableLangs
      }
    }
  }
  
  var addedlangs: some View {
    ViewStateUIBuilder(
      state: viewModel.addedLangs) {
        ProgressView()
      } forError: { error in
        Text(error)
      } forData: { addedLangMap in
        AddedLanguages(
          data: addedLangMap,
          defLang: viewModel.wsData.data?.defLang ?? "",
          onToggleActiveStatus: { langId in
            viewModel.toggleLangActiveStatus(id: langId)
          },
          onSwitchDefault: { langCode in
            viewModel.switchDefaultLang(lang: langCode, workspaceId: data.id)
          }
        )
      } forNoData: {
        Text("No data")
      }
      .onAppear {
        viewModel.fetchWorkspace(workspaceId: data.id)
        viewModel.loadAddedLanguages(workspaceId: data.id)
      }
  }
  
  var availableLangs: some View {
    ViewStateUIBuilder(
      state: viewModel.addedLangs) {
        ProgressView()
      } forError: { error in
        Text(error)
      } forData: { _ in
        AvailableLanguages(data: viewModel.availableLangs) { lang in
          viewModel.addLanguage(lang: lang, workspaceId: data.id)
        }
      } forNoData: {
        Text("No data")
      }
      .onAppear {
        viewModel.loadAllLangs()
      }
  }
}

#Preview {
  
}
