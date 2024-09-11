//
//  ListViews.swift
//  AppStore
//
//  Created by 김주희 on 9/10/24.
//

import SwiftUI

struct RecentListView: View {
    
    let recentSearches: [String]
    var onSearch: (String) -> Void
    
    var body: some View {
        List {
            Section(header: Text("최근 검색어")
                .font(.system(size: 20).bold())) {
                    ForEach(recentSearches, id: \.self) { result in
                        VStack(alignment: .leading) {
                            Text(result)
                                .font(.system(size: 20))
                                .foregroundStyle(Color(uiColor: .systemBlue))
                            Divider()
                        }
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            onSearch(result)
                        }
                    }
            }
        }
        .accessibility(identifier: "RecentListView")
        .listStyle(.plain)
    }
}

struct RelatedListView: View {
    
    let results: [String]
    var onSearch: (String) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            Divider()
                .background(Color(uiColor: .systemGray))
            
            List {
                ForEach(results, id: \.self) { result in
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color(uiColor: .systemGray))
                        
                        Text(result)
                            .font(.system(size: 15))
                    }
                    .onTapGesture {
                        onSearch(result)
                    }
                }
            }
            .listStyle(.plain)
        }
        .background(Color(uiColor: .systemBackground))
    }
}
