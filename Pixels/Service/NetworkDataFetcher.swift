//
//  NetworkDataFetcher.swift
//  Pixels
//
//  Created by Vladimir Fibe on 30.01.2022.
//

import Foundation

class NetworkDataFetcher {
  var networkService = NetworkService()
  func fetchImages(search: String, comletion: @escaping (SearchResults?) -> ()) {
    networkService.request(searchTerm: search) { data, error in
      if let error = error {
        print("DEBUG: Error received requesting date: \(error.localizedDescription)")
        comletion(nil)
      }
      let decode = self.decodeJSON(type: SearchResults.self, from: data)
      comletion(decode)
    }
  }
  
  func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
    let decoder = JSONDecoder()
    guard let data = from else { return nil }
    do {
      let objects = try decoder.decode(type.self, from: data)
      return objects
    } catch {
      print("DEBUG: Failed to decode JSON \(error.localizedDescription)")
      return nil
    }
  }
  func fethcPhoto() {
    
  }
}
