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
                    SearchAppView(apps: viewModel.searchResults)
                } else if isFocus {
                    RelatedListView(results: filteredResults, onSearch: { search in
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
                    
        ZStack {
            VStack(spacing: 0) {
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                List(apps) { app in
                    VStack(alignment: .leading, spacing: 30) {
                        HStack {
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
                        NavigationLink("", destination: AppDetailView(app: app))
                            .opacity(0)
                    )
                }
                .listStyle(.plain)
            }
            
            Text("검색 결과가 없습니다.")
                .font(.system(size: 18).bold())
                .foregroundStyle(Color(uiColor: .systemGray))
                .isHidden(hidden: apps.count != 0, remove: true)
        }
        .background(Color.white)
    }
    
    
    private func starFill(for index: Int, rating: Double) -> Double {
        let starValue = rating - Double(index)
        if starValue >= 1 {
            return 1.0
        } else if starValue > 0 {
            return starValue
        } else {
            return 0.0
        }
    }
    
    private func formattedRatingCount(_ count: Int) -> String {
        if count >= 10_000 {
            let formatted = Double(count) / 10_000
            return String(format: "%.1f만", formatted)
        } else {
            return "\(count)"
        }
        
    }
}

struct StarView: View {
    
    var isFilled: Bool
    
    var body: some View {
        ZStack {
            Image(systemName: "star")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
            
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
    @State private var showTitle: Bool = false
    let app: AppData

    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(alignment: .leading) {
                        AppDetailTitleView(app: app)
                        Divider()
                        AppDetailScreenView(app: app)
                    }
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                showTitle = geo.frame(in: .global).minY < -10
                            }
                            .onChange(of: geo.frame(in: .global).minY) { newValue in
                                showTitle = newValue < -10
                            }
                    }
                )
            }
            .navigationTitle(showTitle ? app.trackName : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    if showTitle {
                        AsyncImage(url: URL(string: app.artworkUrl100)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(uiColor: .systemGray6))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
            }
        }
    }
}

struct AppDetailTitleView: View {
    
    let app: AppData
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: app.artworkUrl100)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            } placeholder: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: .systemGray6))
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110, height: 110)
            }
            
            VStack(alignment: .leading) {
                Text(app.trackName)
                    .font(.system(size: 20).bold())
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("받기")
                        .frame(width: 70, height: 30)
                        .font(.system(size: 16).bold())
                        .foregroundStyle(Color.white)
                        .background(Color(uiColor: .systemBlue), in: Capsule())
                }
            }
            
            Spacer()
        }
        .padding(.init(top: 20, leading: 20, bottom: 20, trailing: 20))
    }
}

struct AppDetailScreenView: View {
    
    let app: AppData
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(app.screenshotUrls, id: \.self) { url in
                    AsyncImage(url: URL(string: url)) { image in
                        image.resizable()
                            .frame(width: 250, height: 450)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(uiColor: .systemGray6))
                            .frame(width: 250, height: 450)
                    }
                }
            }
            .padding(.leading, 20)
            .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    SearchView()
}
