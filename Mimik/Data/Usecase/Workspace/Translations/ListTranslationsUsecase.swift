//
//  ListTranslationsUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 27/11/25.
//
import CoreData

class ListTranslationsUsecase {
  private let repo: WSTranslationRepo
  
  init(repo: WSTranslationRepo) {
    self.repo = repo
  }
  
  func getRootGroup(workspaceId: UUID) async throws -> TranslationGroupDTO {
    var allGroups = try await repo.fetchAllGroups(workspaceId: workspaceId)
    
    let rootGroupIndex = allGroups.firstIndex(
      where: { $0.key == DEFAULT_KEY_ROOT_TRANSLATION_GROUP })
    
    // If root group exists, return it; otherwise create a new default one
    if let index = rootGroupIndex, index != -1 {
      return allGroups[index]
    } else {
      // No root group found - create the default root group
      return try await repo.addDefGroup(workspaceId: workspaceId)
    }
  }
  
  /**
   - t1
   - t2
   - g1
   - t3
   - t4
   - g2
   - t5
   - t6
   - g3
   - t7
   - t8          
   */
  
  func getGroups(
    workspaceId: UUID
  ) async throws -> (TranslationGroupDTO, [TranslationGroupDTO])
  
  //  ([UUID:[TranslationGroupDTO]], TranslationGroupDTO)
  {
    var allGroups = try await repo.fetchAllGroups(workspaceId: workspaceId)
    
    var rootGroup: TranslationGroupDTO
    let rootGroupIndex = allGroups.firstIndex(
      where: { $0.key == DEFAULT_KEY_ROOT_TRANSLATION_GROUP })

    if rootGroupIndex == nil || rootGroupIndex == -1 {
      // create root group
      rootGroup = try await repo.addDefGroup(workspaceId: workspaceId)
    } else {
      rootGroup = allGroups[rootGroupIndex!]
      allGroups.remove(at: rootGroupIndex!)
    }
    
    return (rootGroup, allGroups)
    
    //    var (result, rootGroup) = segregateAsTree(allGroups: allGroups)
    //    
    //    if rootGroup == nil {
    //      // create root group
    //      rootGroup = try await repo.addDefGroup(workspaceId: workspaceId)
    //    }
    //    
    //    for (key, groups) in result {
    //      print("\(key): \(groups.count)")
    //    }
    //    
    //    return (result, rootGroup!)
  }
  
  private func segregateAsTree(
    allGroups: [TranslationGroupDTO]
  ) ->  ([UUID:[TranslationGroupDTO]], TranslationGroupDTO?) {
    var result = [:] as [UUID:[TranslationGroupDTO]]
    
    var rootGroup: TranslationGroupDTO?
    
    for group in allGroups {
      let key = group.key
      let id = group.id
      let parentGroupId = group.parentGroupId

      // default group, only one exists
      if key == DEFAULT_KEY_ROOT_TRANSLATION_GROUP {
        rootGroup = group
        continue
      }
      
      // non-default groups
      if parentGroupId != nil {
        // if we find something where parentGroupId != null
        // then group array should exist
        var existingGroups = result[parentGroupId!]!
        existingGroups.append(group)
        result[parentGroupId!] = existingGroups
      }
      //      else if result.keys.contains(id) {
      //        var existingGroups = result[id]!
      //        existingGroups.append(group)
      //        result[id] = existingGroups
      //        continue
      //      }
      else {
        result[id] = [group]
      }
    }
    return (result, rootGroup)
  }
}
