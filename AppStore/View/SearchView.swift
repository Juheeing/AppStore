//
//  SearchView.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import SwiftUI

struct SearchView: View {
        
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isFocus: Bool
    @State var input: String = ""
    @State private var isInputMode: Bool = false
    @State private var filteredResults: [String] = []
    
    var body: some View {
        
        VStack {
            VStack {
                TopTitleView(title: "검색")
                    .transition(.move(edge: .top))
                    .isHidden(hidden: isInputMode, remove: true)
                
                HStack(spacing: 10) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color(uiColor: .systemGray))
                        
                        TextField("게임, 앱, 스토리 등", text: $input)
                            .focused($isFocus)
                            .submitLabel(.search)
                            .onSubmit {
                                viewModel.saveSearchData(input: input)
                                input = ""
                            }
                            .onChange(of: isFocus) { newValue in
                                isInputMode = newValue
                            }
                            .onChange(of: input) { newValue in
                                isInputMode = true
                                // 입력된 텍스트와 일치하거나 포함된 recentSearches 항목 필터링
                                filteredResults = viewModel.recentSearches.filter { $0.contains(newValue) }
                            }
                    }
                    .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                    .background(Color(uiColor: .systemGray5))
                    .cornerRadius(7)
                    
                    Button(action: {
                        isFocus = false
                        isInputMode = false
                    }, label: {
                        Text("취소")
                    })
                    .isHidden(hidden: !isInputMode, remove: true)
                }
            }
            .padding(.init(top: isInputMode ? 10 : 50, leading: 20, bottom: 0, trailing: 20))
            
            RecentListView(recentSearches: viewModel.recentSearches)
                .isHidden(hidden: isInputMode, remove: true)
            
            RelatedListView(results: filteredResults)
                .isHidden(hidden: !isInputMode, remove: true)
        }
        .background(isInputMode ? Color(uiColor: .systemGray6) : Color.white)
    }
}

struct RecentListView: View {
    
    let recentSearches: [String]
    
    var body: some View {
        List {
            Section(header: Text("최근 검색어")
                .foregroundStyle(.black)
                .font(.system(size: 20).bold())) {
                    ForEach(recentSearches, id: \.self) { search in
                        VStack(alignment: .leading) {
                            Text(search)
                                .font(.system(size: 20))
                                .foregroundStyle(Color(uiColor: .systemBlue))
                            Divider()
                        }
                        .listRowSeparator(.hidden)
                    }
            }
        }
        .listStyle(.plain)
    }
}

struct RelatedListView: View {
    
    let results: [String]  // 필터링된 검색어 목록
    
    var body: some View {
        VStack(spacing: 0) {
            
            Divider()
                .background(Color(uiColor: .systemGray))
            
            List {
                ForEach(results, id: \.self) { result in  // ForEach 사용
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color(uiColor: .systemGray))
                        
                        Text(result)  // 필터링된 검색어 표시
                            .font(.system(size: 15))
                            .foregroundStyle(Color.black)
                    }
                }
            }
            .listStyle(.plain)
        }
        .background(Color.white)
    }
}

#Preview {
    SearchView()
}
