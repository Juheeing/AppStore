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
    func saveSearchData(input: String) {
        guard !input.isEmpty else { return }
            
        // 배열에 이미 있는 경우 기존 값을 제거
        if let index = recentSearches.firstIndex(of: input) {
            recentSearches.remove(at: index)
        }
        
        // 배열의 앞에 삽입
        recentSearches.insert(input, at: 0)
        
        searchApp(input: input)  // 검색어 저장 후 앱 검색
    }
    
    // iTunes Search API 호출 함수
    func searchApp(input: String) {
        let searchTerm = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(SearchResult.self, from: data)
                    DispatchQueue.main.async {
                        self.searchResults = result.results
                        for app in result.results {
                            print("앱 이름: \(app.trackName), 설명: \(app.description)")
                        }
                    }
                } catch {
                    print("Error decoding: \(error)")
                }
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }
        task.resume()
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
