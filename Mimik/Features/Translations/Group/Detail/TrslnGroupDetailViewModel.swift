//
//  TrslnGroupDetailViewModel.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 04/05/26.
//

import Foundation

@Observable
class TrslnGroupDetailViewModel {
  private let detailUsecase: TranslationGroupDetailUsecase
  private let getWorkspaceUsecase: GetWorkspaceUsecase
  private let langUsecase: AddLanguageUsecase
  private let valueUsecase: TranslationValueUsecase
  private let listAppsUsecase: ListWorkspaceAppsUsecase

  init(
    detailUsecase: TranslationGroupDetailUsecase,
    getWorkspaceUsecase: GetWorkspaceUsecase,
    langUsecase: AddLanguageUsecase,
    valueUsecase: TranslationValueUsecase,
    listAppsUsecase: ListWorkspaceAppsUsecase,
  ) {
    self.detailUsecase = detailUsecase
    self.getWorkspaceUsecase = getWorkspaceUsecase
    self.langUsecase = langUsecase
    self.valueUsecase = valueUsecase
    self.listAppsUsecase = listAppsUsecase
  }

  var childGroups: ViewState<[TranslationGroupDTO]> = .loading()
  var keys: ViewState<[KeyListItem]> = .loading()
  var workspaceApps: ViewState<[WSAppDTO]> = .loading()

  /// Loads the direct subgroups and keys that live inside `groupId`, plus
  /// enough language/value data to show each key's default-language
  /// translation and how many active languages still need one.
  func load(groupId: UUID, workspaceId: UUID) {
    childGroups = .loading()
    keys = .loading()
    workspaceApps = .loading()
    Task {
      do {
        async let childrenTask = detailUsecase.getChildren(id: groupId)
        async let rawKeysTask = detailUsecase.getKeys(groupId: groupId)
        async let workspaceTask = getWorkspaceUsecase.get(id: workspaceId)
        async let addedLangsTask = langUsecase.getAddedLanguages(workspaceId: workspaceId)
        async let appsTask = listAppsUsecase.list(workspaceId: workspaceId)

        let (children, rawKeys, workspace, addedLangs, apps) = try await (
          childrenTask, rawKeysTask, workspaceTask, addedLangsTask, appsTask
        )

        let activeLangCodes = addedLangs.values
          .filter { $0.active }
          .map { $0.code }

        let values = try await valueUsecase.getValues(forKeyIds: rawKeys.map { $0.id })
        let valuesByKeyId = Dictionary(grouping: values, by: { $0.keyId })

        let items = rawKeys.map { key -> KeyListItem in
          let keyValues = valuesByKeyId[key.id] ?? []
          let valuesByLang = Dictionary(
            keyValues.map { ($0.lang, $0.value) },
            uniquingKeysWith: { _, latest in latest }
          )
          let translatedCount = activeLangCodes.filter {
            !(valuesByLang[$0] ?? "").isEmpty
          }.count

          return KeyListItem(
            key: key,
            defaultLangValue: valuesByLang[workspace.defLang],
            translatedCount: translatedCount,
            totalLanguages: activeLangCodes.count
          )
        }

        await MainActor.run {
          childGroups = .success(data: children)
          keys = .success(data: items)
          workspaceApps = .success(data: apps)
        }
      } catch {
        await MainActor.run {
          childGroups = .failure(error: "Failed to load subgroups for this group")
          keys = .failure(error: "Failed to load keys for this group")
          workspaceApps = .failure(error: "Failed to load this workspace's apps")
        }
      }
    }
  }
}
