//
//  LangDataSource.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

import Foundation

final class LangDataSource {
  private let languages: [LangDTO]
  
  init() {
    let url = Bundle.main.url(forResource: "lang", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    languages = try! JSONDecoder().decode([LangDTO].self, from: data)
  }
  
  func getAll() -> [LangDTO] {
    return languages
  }
}
