//
//  TranslationGroupDetailUsecase.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 04/05/26.
//

import Foundation

class TranslationGroupDetailUsecase {
  private let repo: WSTranslationRepo

  init(repo: WSTranslationRepo) {
    self.repo = repo
  }
  
  func getGroup(
    id: UUID
  ) async throws -> TranslationGroupDTO {
    let res = try await repo.fetchGroup(id: id)
    if res == nil {
      throw FetchError.NotFound
    }
    return res!
  }
  
  func getChildren(id: UUID) async throws -> [TranslationGroupDTO] {
    return try await repo.fetchGroupsByParent(parentId: id)
  }
  
  func getRootGroupsByWorkspaceId(workspaceId: UUID) async throws -> [TranslationGroupDTO] {
    return try await repo.fetchRootGroupsByWorkspaceId(workspaceId: workspaceId)
  }

  func load(
    group: TranslationGroupDTO,
    workspaceId: UUID
  ) async throws -> GroupDetailData {
//    // 1. Fetch all groups and active language codes in parallel
//    async let allGroupsTask = repo.fetchAllGroups(workspaceId: workspaceId)
//    async let langCodesTask = repo.fetchActiveLanguageCodes(workspaceId: workspaceId)
//    let (allGroups, languageCodes) = try await (allGroupsTask, langCodesTask)
//
//    // 2. Compute depth by traversing parent chain
//    let depth = computeDepth(group: group, allGroups: allGroups)
//
//    // 3. Direct subgroups and all descendant IDs for recursive stats
//    let subgroups = allGroups.filter { $0.parentGroupId == group.id }
//    let allDescendantIds = getAllDescendantIds(groupId: group.id, allGroups: allGroups)
//    let scopeIds: [UUID] = [group.id] + allDescendantIds
//
//    // 4. Fetch keys and values in parallel
//    async let allKeysTask = repo.fetchKeysByGroupIds(scopeIds)
//    let allKeys = try await allKeysTask
//    let keyIds = allKeys.map { $0.id }
//    let allValues = try await repo.fetchValues(forKeyIds: keyIds)
//
//    // 5. Build lookup maps
//    let valuesByKeyId: [UUID: [TranslationValueDTO]] = Dictionary(
//      grouping: allValues, by: { $0.keyId }
//    )
//    let keysByGroupId: [UUID: [TranslationKeyDTO]] = Dictionary(
//      grouping: allKeys, by: { $0.groupId ?? UUID() }
//    )
//
//    // 6. Compute header stats (recursive)
//    let totalMissing = computeMissing(keys: allKeys, valuesByKeyId: valuesByKeyId, langCodes: languageCodes)
//    let totalSlots = allKeys.count * languageCodes.count
//    let coverage = totalSlots > 0 ? Double(totalSlots - totalMissing) / Double(totalSlots) * 100 : 100
//    let stats = GroupStat(
//      subgroupCount: subgroups.count,
//      totalKeyCount: allKeys.count,
//      missingCount: totalMissing,
//      coverage: coverage
//    )
//
//    // 7. Compute per-subgroup stats (direct only)
//    var subgroupStats: [UUID: SubgroupStat] = [:]
//    for sub in subgroups {
//      let subDirectKeys = keysByGroupId[sub.id] ?? []
//      let subKeyIds = subDirectKeys.map { $0.id }
//      let subValues = subKeyIds.flatMap { valuesByKeyId[$0] ?? [] }
//      let subMissing = computeMissing(
//        keys: subDirectKeys,
//        valuesByKeyId: Dictionary(grouping: subValues, by: { $0.keyId }),
//        langCodes: languageCodes
//      )
//      let subSlots = subDirectKeys.count * languageCodes.count
//      let subCoverage = subSlots > 0 ? Double(subSlots - subMissing) / Double(subSlots) * 100 : 100
//      subgroupStats[sub.id] = SubgroupStat(
//        keyCount: subDirectKeys.count,
//        subCount: allGroups.filter { $0.parentGroupId == sub.id }.count,
//        missingCount: subMissing,
//        coverage: subCoverage
//      )
//    }
//
//    // 8. Build direct keys with values for the table
//    let directKeys = (keysByGroupId[group.id] ?? []).map { key in
//      let keyValues = valuesByKeyId[key.id] ?? []
//      return KeyWithValues(
//        key: key,
//        values: Dictionary(uniqueKeysWithValues: keyValues.map { ($0.lang, $0) })
//      )
//    }
//
//    return GroupDetailData(
//      subgroups: subgroups,
//      subgroupStats: subgroupStats,
//      directKeys: directKeys,
//      stats: stats,
//      depth: depth,
//      languageCodes: languageCodes
//    )
    return GroupDetailData(
      subgroups: [],
      subgroupStats: [:],
      directKeys: [],
      stats: GroupStat(
        subgroupCount: 0,
        totalKeyCount: 0,
        missingCount: 0,
        coverage: 0.0
      ),
      depth: 0,
      languageCodes: []
    )
  }

  // MARK: - Private helpers

  private func computeDepth(group: TranslationGroupDTO, allGroups: [TranslationGroupDTO]) -> Int {
    var depth = 0
    var currentId: UUID? = group.parentGroupId
    while let id = currentId {
      let parent = allGroups.first { $0.id == id }
      guard let parent else { break }
      // Don't count the root group as a depth level
      if parent.key != DEFAULT_KEY_ROOT_TRANSLATION_GROUP {
        depth += 1
      }
      currentId = parent.parentGroupId
    }
    return depth
  }

  private func getAllDescendantIds(groupId: UUID, allGroups: [TranslationGroupDTO]) -> [UUID] {
    let directChildren = allGroups.filter { $0.parentGroupId == groupId }
    return directChildren.flatMap { child in
      [child.id] + getAllDescendantIds(groupId: child.id, allGroups: allGroups)
    }
  }

  private func computeMissing(
    keys: [TranslationKeyDTO],
    valuesByKeyId: [UUID: [TranslationValueDTO]],
    langCodes: [String]
  ) -> Int {
    var missing = 0
    for key in keys {
      let values = valuesByKeyId[key.id] ?? []
      let filledLangs = Set(values.map { $0.lang })
      for lang in langCodes where !filledLangs.contains(lang) {
        missing += 1
      }
    }
    return missing
  }
}
