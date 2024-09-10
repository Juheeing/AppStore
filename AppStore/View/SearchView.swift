//
//  SearchView.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import SwiftUI

struct SearchView: View {
        
    @EnvironmentObject var global: Global
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isFocus: Bool
    @State var input: String = ""
    @State private var isInputMode: Bool = false
    @State private var filteredResults: [String] = []
    
    var body: some View {
        
        NavigationView {
            VStack {
                VStack {
                    TopTitleView(title: "검색")
                        .transition(.move(edge: .top))
                        .isHidden(hidden: isInputMode || viewModel.searchComplete, remove: true)
                    
                    HStack(spacing: 10) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color(uiColor: .systemGray))
                            
                            TextField("게임, 앱, 스토리 등", text: $input)
                                .focused($isFocus)
                                .submitLabel(.search)
                                .onSubmit {
                                    viewModel.saveSearchData(input: input, global: global)
                                }
                                .onChange(of: isFocus) { newValue in
                                    isInputMode = newValue
                                }
                                .onChange(of: input) { newValue in
                                    if newValue != "" {
                                        isInputMode = true
                                        filteredResults = viewModel.recentSearches.filter { $0.contains(newValue) }
                                    }
                                }
                        }
                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .background(Color(uiColor: .systemGray5))
                        .cornerRadius(7)
                        
                        Button(action: {
                            isFocus = false
                            viewModel.searchComplete = false
                            isInputMode = false
                            input = ""
                        }, label: {
                            Text("취소")
                        })
                        .isHidden(hidden: !isInputMode && !viewModel.searchComplete, remove: true)
                    }
                }
                .padding(.init(top: isInputMode || viewModel.searchComplete ? 10 : 50, leading: 20, bottom: 0, trailing: 20))
                
                if viewModel.searchComplete {
                    SearchResultView(apps: viewModel.searchResults)
                } else if isFocus {
                    RelatedListView(results: filteredResults, onSearch: { search in
                        isFocus = false
                        isInputMode = true
                        input = search
                        viewModel.saveSearchData(input: input, global: global)
                    })
                } else {
                    RecentListView(recentSearches: viewModel.recentSearches, onSearch: { search in
                        isInputMode = true
                        input = search
                        viewModel.saveSearchData(input: input, global: global)
                    })
                }
            }
            .background(isInputMode || viewModel.searchComplete ? Color(uiColor: .systemGray6) : Color.white)
            .hiddenNavigationBarStyle()
            .navigationTitle("검색")
        }
    }
}
