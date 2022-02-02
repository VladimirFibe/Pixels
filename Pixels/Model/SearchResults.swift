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
  let created_at: String
  
  enum URLKind: String {
    case raw
    case full
    case regular
    case small
    case thumb
  }
}
/*
 Экран подробной информации содержит в себе фотографию, имя автора, дату создания, местоположение и количество скачиваний.
 Также экран содержит кнопку, нажатие на которую может добавить фотографию в список любимых фотографий и удалить из него.
 При желании можно сделать этот список редактируемым.
 */
