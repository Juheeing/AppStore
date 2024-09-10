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
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct AppData: Codable, Identifiable {
    let id: Int  // trackId가 "id"로 매핑됨
    let screenshotUrls: [String]  // 스크린샷 (문자열 배열)
    let trackName: String   // 앱 이름
    let averageUserRating: Double?  // 별점
    let userRatingCount: Int?        // 별점 개수
    let description: String     // 앱 설명
    let artworkUrl100: String   // 앱 아이콘
    let releaseNotes: String
    let version: String
    let sellerName: String
    let contentAdvisoryRating: String
    let languageCodesISO2A: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case screenshotUrls
        case trackName
        case averageUserRating
        case userRatingCount
        case description = "description"
        case artworkUrl100
        case releaseNotes
        case version
        case sellerName
        case contentAdvisoryRating
        case languageCodesISO2A
    }
}
