//
//  GroupDetailData.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 04/05/26.
//

import Foundation

/// What the translations list screen needs to render one row: the key
/// itself, its value in the workspace's default language (if any), and
/// how many of the workspace's active languages already have a value.
struct KeyListItem: Identifiable {
  let key: TranslationKeyDTO
  let defaultLangValue: String?
  let translatedCount: Int
  let totalLanguages: Int

  var id: UUID { key.id }

  var isFullyTranslated: Bool {
    totalLanguages > 0 && translatedCount == totalLanguages
  }
}
