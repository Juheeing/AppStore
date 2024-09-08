//
//  SearchModel.swift
//  AppStore
//
//  Created by 김주희 on 9/8/24.
//

import Foundation

// iTunes API 결과를 디코딩하기 위한 구조체
struct SearchResult: Codable {
    let results: [AppData]
}

struct AppData: Codable, Identifiable {
    let id: Int  // trackId가 "id"로 매핑됨
    let trackName: String
    let description: String
    let artworkUrl100: String
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case description = "description"
        case artworkUrl100
    }
}
