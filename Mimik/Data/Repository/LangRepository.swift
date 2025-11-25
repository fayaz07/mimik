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
  
  func getAll() -> [LangDTO] {
    return dataSource.getAll()
  }
}
