//
//  LangDataSource.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

import Foundation

final class LangDataSource {
  private let languages: [String: LangDTO]
  
  init() {
    let url = Bundle.main.url(forResource: "lang", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    let list = try! JSONDecoder().decode([LangDTO].self, from: data)
    languages = Dictionary(uniqueKeysWithValues: list.map{ ($0.code, $0) })
  }
  
  func getAll() -> [String: LangDTO] {
    return languages
  }
}
