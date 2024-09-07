//
//  SearchView.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import SwiftUI

struct SearchView: View {
        
    @FocusState private var isFocus: Bool
    @State var input: String = ""
    @State private var isInputMode: Bool = false
    
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
                            .onChange(of: isFocus) { newValue in
                                isInputMode = newValue
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
            
            RecentListView()
                .isHidden(hidden: isInputMode, remove: true)
            
            RelatedListView()
                .isHidden(hidden: !isInputMode, remove: true)
        }
        .background(isInputMode ? Color(uiColor: .systemGray6) : Color.white)
    }
}

struct RecentListView: View {
    var body: some View {
        List {
            Section(header: Text("최근 검색어")
                .foregroundStyle(.black)
                .font(.system(size: 20).bold())) {
                    VStack(alignment: .leading) {
                        Text("test")
                            .font(.system(size: 20))
                            .foregroundStyle(Color(uiColor: .systemBlue))
                        Divider()
                    }
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

struct RelatedListView: View {
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(uiColor: .systemGray))
            List {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color(uiColor: .systemGray))
                    
                    Text("test")
                        .font(.system(size: 15))
                        .foregroundStyle(Color.black)
                }
                .listRowSeparator(.hidden, edges: .top)
            }
            .listStyle(.plain)
        }
        .background(Color.white)
    }
}

#Preview {
    SearchView()
}
