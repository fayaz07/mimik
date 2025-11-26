//
//  AuthorDTO.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 26/11/25.
//

import Foundation

struct AuthorDTO: Codable {
  let name: String
}

func ParseAuthorDTO(from json: String) -> AuthorDTO {
  do {
    return try JSONDecoder().decode(AuthorDTO.self, from: json.data(using: .utf8)!)
  } catch {
    return AuthorDTO(
      name: "Unknown"
    )
  }
}
