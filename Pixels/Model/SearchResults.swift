//
//  SearchResults.swift
//  Pixels
//
//  Created by Vladimir Fibe on 30.01.2022.
//

import Foundation

struct SearchResults: Decodable {
  let total: Int
  let results: [UnSplashPhoto]
}

struct UnSplashPhoto: Decodable {
  let width: Int
  let height: Int
  let urls: [URLKind.RawValue: String]
  
  enum URLKind: String {
    case raw
    case full
    case regular
    case small
    case thumb
  }
}
