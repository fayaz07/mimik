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
  private let getWorkspaceUsecase: GetWorkspaceUsecase
  private let switchLanguageUsecase: SwitchDefaultLanguageUsecase
  private let toggleLangStatusUsecase: ToggleLangStatusUsecase
  
  init(
    usecase: AddLanguageUsecase,
    getWorkspaceUsecase: GetWorkspaceUsecase,
    switchLanguageUsecase: SwitchDefaultLanguageUsecase,
    toggleLangStatusUsecase: ToggleLangStatusUsecase
  ) {
    self.usecase = usecase
    self.getWorkspaceUsecase = getWorkspaceUsecase
    self.switchLanguageUsecase = switchLanguageUsecase
    self.toggleLangStatusUsecase = toggleLangStatusUsecase
  }

  var addedLangs: ViewState<[String: WSLangDTO]> = .init(loading: true)
  var allLangs: ViewState<[String: LangDTO]> = .init(loading: true)
  var wsData: ViewState<WorkspaceDTO> = .init(loading: true)
  
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
  
  // TODO: handle error
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
  
  func fetchWorkspace(workspaceId: UUID) {
    if wsData.hasData {
      return
    }
    wsData = .loading()
    Task {
      do {
        let result = try await getWorkspaceUsecase.get(id: workspaceId)
        await MainActor.run {
          self.wsData = .success(data: result)
        }
      }
    }
  }
  
  // TODO: handle error
  func switchDefaultLang(lang: String, workspaceId: UUID) {
    Task {
      do {
        await MainActor.run {
          wsData = .init(loading: true, data: nil)
        }
        let workspaceRes = try await switchLanguageUsecase.execute(
          id: workspaceId,
          lang: lang
        )
        await MainActor.run {
          self.wsData = .success(data: workspaceRes!)
        }
      } catch {
        fetchWorkspace(workspaceId: workspaceId)
      }
    }
  }
  
  // TODO: handle error
  func toggleLangActiveStatus(id: UUID) {
    Task {
      do {
        guard let entity = try await toggleLangStatusUsecase.execute(
          languageId: id
        )
        else { return }
        
        let langDoc = allLangs.data?[entity.code!]

        let dto = entity.toDTO(lang: langDoc!)
        
        // 3. Now safely update UI on MainActor
        await MainActor.run {
          var addedLangsList = addedLangs.data ?? [:]

          guard let old = addedLangsList.first(where: { $0.value.id == id })
          else { return }
          addedLangsList.removeValue(forKey: old.key)
 
          addedLangsList[dto.code] = dto
          
          addedLangs = .success(data: addedLangsList)
        }
      } catch {
        print(error)
      }
    }
  }
}
