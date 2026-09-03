//
//  GroupDetailData.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 04/05/26.
//

import Foundation

struct SubgroupStat {
  let keyCount: Int
  let subCount: Int
  let missingCount: Int
  let coverage: Double

  var isEmpty: Bool { keyCount == 0 && subCount == 0 }
}

struct GroupStat {
  let subgroupCount: Int
  let totalKeyCount: Int
  let missingCount: Int
  let coverage: Double

  static let zero = GroupStat(subgroupCount: 0, totalKeyCount: 0, missingCount: 0, coverage: 100)
}

struct KeyWithValues {
  let key: TranslationKeyDTO
  let values: [String: TranslationValueDTO]
}

struct GroupDetailData {
  let subgroups: [TranslationGroupDTO]
  let subgroupStats: [UUID: SubgroupStat]
  let directKeys: [KeyWithValues]
  let stats: GroupStat
  let depth: Int
  let languageCodes: [String]
}

enum GroupDetailEvent: Equatable {
  case renamed(TranslationGroupDTO)
  case deleted
}
