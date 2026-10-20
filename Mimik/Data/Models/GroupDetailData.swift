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

  /// Whether this key shows up for `app` - true for every key when `app`
  /// is nil (no filter/"All Apps"), otherwise false if this key has been
  /// specifically excluded from that app.
  func isIncluded(in app: WSAppDTO?) -> Bool {
    guard let app else { return true }
    return !key.excludedApps.contains(app.id)
  }
}
