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
                    SearchAppView(apps: viewModel.searchResults)
                } else if isFocus {
                    RelatedListView(results: filteredResults, onSearch: { search in
                        isInputMode = true
                        input = search
                        viewModel.saveSearchData(input: input, global: global)
                    })
                } else {
                    RecentListView(recentSearches: viewModel.recentSearches, onSearch: { search in
                        isFocus = true
                        isInputMode = true
                        input = search
                        viewModel.saveSearchData(input: input, global: global)
                    })
                }
            }
            .background(isInputMode || viewModel.searchComplete ? Color(uiColor: .systemGray6) : Color.white)
            .hiddenNavigationBarStyle()
        }
    }
}

struct RecentListView: View {
    
    let recentSearches: [String]
    var onSearch: (String) -> Void
    
    var body: some View {
        List {
            Section(header: Text("최근 검색어")
                .foregroundStyle(.black)
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
        .listStyle(.plain)
    }
}

struct RelatedListView: View {
    
    let results: [String]  // 필터링된 검색어 목록
    var onSearch: (String) -> Void
    
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
                    .onTapGesture {
                        onSearch(result)
                    }
                }
            }
            .listStyle(.plain)
        }
        .background(Color.white)
    }
}

struct SearchAppView: View {
    
    let apps: [AppData]
    
    var body: some View {
                    
        VStack(spacing: 0) {
            
            Divider()
                .background(Color(uiColor: .systemGray))
            
            List(apps) { app in
                VStack(alignment: .leading, spacing: 30) {
                    HStack {
                        // 앱 아이콘
                        AsyncImage(url: URL(string: app.artworkUrl100)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(uiColor: .systemGray6))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(app.trackName)
                                .font(.system(size: 15))
                            
                            HStack {
                                HStack(spacing: 1) {
                                    ForEach(0..<5) { index in
                                        StarView(isFilled: index < Int(app.averageUserRating ?? 0))
                                            .frame(width: 12, height: 12)
                                    }
                                }
                                
                                Text(formattedRatingCount(app.userRatingCount ?? 0))
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(uiColor: .systemGray2))
                            }
                        }
                    }
                    
                    // 최대 3개의 스크린샷을 표시
                    HStack(spacing: 10) {
                        ForEach(app.screenshotUrls.prefix(3), id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(uiColor: .systemGray6))
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                    .isHidden(hidden: app.screenshotUrls.isEmpty, remove: true)
                }
                .listRowSeparator(.hidden)
                .padding(.init(top: 20, leading: 10, bottom: 20, trailing: 10))
                .background(
                    NavigationLink("", destination: AppDetailView())
                        .opacity(0)
                )
            }
            .listStyle(.plain)
        }
        .background(Color.white)
    }
    
    
    private func starFill(for index: Int, rating: Double) -> Double {
        let starValue = rating - Double(index)
        if starValue >= 1 {
            return 1.0 // 완전히 채워진 별
        } else if starValue > 0 {
            return starValue // 부분적으로 채워진 별
        } else {
            return 0.0 // 채워지지 않은 별
        }
    }
    
    private func formattedRatingCount(_ count: Int) -> String {
        if count >= 10_000 {
            // 만 단위로 표시 (예: 1.1만)
            let formatted = Double(count) / 10_000
            return String(format: "%.1f만", formatted)
        } else {
            // 10,000 미만일 때는 그냥 숫자로 표시
            return "\(count)"
        }
        
    }
}

struct StarView: View {
    
    var isFilled: Bool
    
    var body: some View {
        ZStack {
            // 빈 별 테두리
            Image(systemName: "star")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
            
            // 별점이 1 이상일 때 채워진 별
            if isFilled {
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct AppDetailView: View {
    var body: some View {
        Text("test")
    }
}

#Preview {
    SearchView()
}
