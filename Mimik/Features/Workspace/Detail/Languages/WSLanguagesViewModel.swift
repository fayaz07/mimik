//
//  WorkspaceLanguagesViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

import CoreData
import Foundation

@Observable
class WSLanguagesViewModel {
  private let usecase: AddLanguageUsecase
  
  init(usecase: AddLanguageUsecase) {
    self.usecase = usecase
  }

  var addedLangs: ViewState<[String: WSLangDTO]> = .init(loading: true)
  var allLangs: ViewState<[String: LangDTO]> = .init(loading: true)
  
  var availableLangs: [String: LangDTO] {
    guard let all = allLangs.data,
          let added = addedLangs.data else {
      return [:]
    }
        
    return all.filter { key, _ in
      added[key] == nil
    }
  }
  
  func loadAllLangs() {
    if allLangs.hasData {
      return
    }
    allLangs = .loading()
    let result = usecase.getAllLanguages()
    allLangs = .success(data: result)
  }
    
  func loadAddedLanguages(workspaceId: UUID) {
    if addedLangs.hasData {
      return
    }
    addedLangs = .loading()
    Task {
      do {
        let result = try await usecase.getAddedLanguages(
          workspaceId: workspaceId
        )
        await MainActor.run {
          addedLangs = .success(data: result)
        }
      } catch {
        await MainActor.run {
          addedLangs = .failure(error: "Failed to load added languages")
        }
      }
    }
  }
  
  func addLanguage(lang: LangDTO, workspaceId: UUID) {
    if addedLangs.data?.keys.contains(lang.code) == true {
      return
    }
    
    Task {
      do {
        _ = try await usecase.add(lang: lang.code, workspaceId: workspaceId)
        await MainActor.run {
          addedLangs = .init(loading: true, data: nil)
          self.loadAddedLanguages(workspaceId: workspaceId)
        }
      } catch {
        
      }
    }
  }
}
