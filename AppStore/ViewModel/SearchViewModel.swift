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
    
    @Published var searchResults: [AppData] = []
    
    private let searchesKey = "recentSearches"
    
    init() {
        loadSearches()
    }
    
    // 검색어를 UserDefaults에 저장하는 함수
    func saveSearchData(input: String, global: Global) {
        guard !input.isEmpty else { return }
            
        // 배열에 이미 있는 경우 기존 값을 제거
        if let index = recentSearches.firstIndex(of: input) {
            recentSearches.remove(at: index)
        }
        
        // 배열의 앞에 삽입
        recentSearches.insert(input, at: 0)
        
        global.showLoading()
        
        SearchAPI.searchApps(term: input) { data, response, error in
            guard error == nil, let response = response as? HTTPURLResponse, let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = result.results
                    for app in result.results {
                        print("앱 이름: \(app.trackName), 별점: \(String(describing: app.averageUserRating)), 별점 개수: \(String(describing: app.userRatingCount))")
                    }
                }
            } catch {
                print("Error decoding: \(error)")
            }
            DispatchQueue.main.async {
                global.hideLoading()
            }
        }
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
