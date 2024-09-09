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
    @Published var searchComplete: Bool = false
    
    private let searchesKey = "recentSearches"
    
    init() {
        loadSearches()
    }
    
    // 검색어 저장 함수
    func saveSearchData(input: String, global: Global) {
        guard !input.isEmpty else { return }
        
        if let index = recentSearches.firstIndex(of: input) {
            recentSearches.remove(at: index)
        }
        recentSearches.insert(input, at: 0)
        
        global.showLoading()
        
        SearchAPI.searchApps(term: input) { data, response, error in
            DispatchQueue.main.async {
                global.hideLoading()
                guard error == nil, let response = response as? HTTPURLResponse, let data = data else {
                    print("네트워크 오류: \(String(describing: error))")
                    return
                }
                
                switch response.statusCode {
                case 200...299:
                    do {
                        let result = try JSONDecoder().decode(SearchResult.self, from: data)
                        self.searchResults = result.results
                        self.searchComplete = true
                    } catch {
                        print("디코딩 오류: \(error.localizedDescription)")
                    }
                case 400...499:
                    print("클라이언트 오류: \(response.statusCode)")
                case 500...599:
                    print("서버 오류: \(response.statusCode)")
                default:
                    print("알 수 없는 상태 코드: \(response.statusCode)")
                }
            }
        }
    }
    
    // UserDefaults에 검색어 저장
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
