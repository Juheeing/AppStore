//
//  SearchAPI.swift
//  AppStore
//
//  Created by 김주희 on 9/8/24.
//

import Foundation

class SearchAPI {
    
    static var dataTask: URLSessionDataTask?
    
    static var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        return components
    }
    
    static func searchApps(term: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        var components = urlComponents
        components.path = "/search"
        components.queryItems = [
            URLQueryItem(name: "entity", value: "software"),
            URLQueryItem(name: "term", value: term) ]
            
        guard let url = components.url else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask = URLSession.shared.dataTask(with: url, completionHandler: completion)
        dataTask?.resume()
    }
}
