//
//  Supported.swift
//  Mimik
//
//  Created by Fayaz Mohammad on 19/11/25.
//

class SupportedPlatforms {
  static let ANDROID = MimikPlatformType(
    id: "android",
    name: "Android",
    icon: "Android"
  )
  static let IOS = MimikPlatformType(
    id: "ios",
    name: "iOS",
    icon: "Apple"
  )
  static let REACT = MimikPlatformType(
    id: "react",
    name: "React",
    icon: "React"
  )
  
  static let list: [MimikPlatformType] = [
    ANDROID,
    IOS,
    REACT
  ]
  
  static func getImage(for platformId: String) -> String {
    switch platformId {
      case ANDROID.id:
        return ANDROID.icon
      case IOS.id:
        return IOS.icon
      case REACT.id:
        return REACT.icon
      default:
        return ""
    }
  }
}
