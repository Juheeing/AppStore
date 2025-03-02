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
    
    // 앱 검색 API 요청 함수
    static func searchApps(term: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        let currentRegionCode = Locale.current.regionCode ?? "KR"
        
        var components = urlComponents
        components.path = "/search"
        components.queryItems = [
            URLQueryItem(name: "entity", value: "software"),
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "country", value: currentRegionCode)
        ]

        guard let url = components.url else {
            let error = NSError(domain: "URLCreationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL 생성 실패"])
            completion(nil, nil, error)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask = URLSession.shared.dataTask(with: request, completionHandler: completion)
        dataTask?.resume()
    }
}
