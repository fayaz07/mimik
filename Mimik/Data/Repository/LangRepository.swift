//
//  LangRepository.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 25/11/25.
//

class LangRepository {
  private let dataSource: LangDataSource
  
  init(dataSource: LangDataSource) {
    self.dataSource = dataSource
  }
  
  func getAll() -> [String: LangDTO] {
    return dataSource.getAll()
  }
  
  func get(code: String) -> LangDTO {
    return getAll()[code] ?? .init(code: code, name: "Unknown", rtl: false)
  }
  
  func isValid(code: String) -> Bool {
    return getAll().keys.contains(code)
  }
}
