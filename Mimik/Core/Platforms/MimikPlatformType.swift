//
//  MimikPlatformType.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//
import AppKit

struct MimikPlatformType: Hashable {
  let id: String
  let name: String
  let icon: String
  
  var getImage: NSImage? {
    return NSImage(named: icon)
  }
}
