//
//  SearchViewModel.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    
    @Published var recentSearches: [String] = [] {
        didSet {
            saveSearches()
        }
    }
    
    private let searchesKey = "recentSearches"
    
    init() {
        loadSearches()
    }
    
    // 검색어를 UserDefaults에 저장하는 함수
    func saveSearchData(input: String) {
        guard !input.isEmpty else { return }
        recentSearches.append(input)
    }
    
    // UserDefaults에 검색어를 저장
    private func saveSearches() {
        UserDefaults.standard.set(recentSearches, forKey: searchesKey)
    }
    
    // 앱 시작 시 UserDefaults에서 검색어 불러오기
    private func loadSearches() {
        if let savedSearches = UserDefaults.standard.array(forKey: searchesKey) as? [String] {
            recentSearches = savedSearches
        }
    }
}
