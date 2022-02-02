//
//  NetworkService.swift
//  Pixels
//
//  Created by Vladimir Fibe on 30.01.2022.
//

import Foundation

class NetworkService {
  func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
    let url = self.url(params: ["query": searchTerm, "page": "1", "per_page": "30"])
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = ["Authorization": "Client-ID "]
    request.httpMethod = "get"
    let task = createDataTask(from: request, completion: completion)
    task.resume()
  }
  
  private func url(params: [String: String]) -> URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.unsplash.com"
    components.path = "/search/photos"
    components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
    return components.url!
  }
  
  private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
    return URLSession.shared.dataTask(with: request) { data, response, error in
      DispatchQueue.main.async {
        completion(data, error)
      }
    }
  }
}
