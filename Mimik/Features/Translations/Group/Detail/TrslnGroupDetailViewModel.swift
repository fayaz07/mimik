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
  
  init(
    detailUsecase: TranslationGroupDetailUsecase,
  ) {
    self.detailUsecase = detailUsecase
  }
  
  var childGroups: ViewState<[TranslationGroupDTO]> = .loading()
  
  func load(
    groupId: UUID,
    workspaceId: UUID,
    isWorkspaceRoot: Bool
  ) {
    childGroups = .loading()
    Task {
      do {
        if isWorkspaceRoot {
          let data = try await detailUsecase.getRootGroupsByWorkspaceId(workspaceId: workspaceId)
          await MainActor.run {
            childGroups = .success(data: data)
          }
        } else {
          let data = try await detailUsecase.getChildren(id: groupId)
          await MainActor.run {
            childGroups = .success(data: data)
          }
        }
      } catch {
        await MainActor.run {
          childGroups = .failure(error: "Failed to load child groups for group id: \(groupId)")
        }
      }
    }
  }
}
