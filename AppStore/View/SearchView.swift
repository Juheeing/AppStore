//
//  SearchView.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import SwiftUI

struct SearchView: View {
        
    var body: some View {
        
        VStack(spacing: 0) {
            InputView()
            RecentListView()
        }
    }
}

struct InputView: View {
    
    @FocusState private var isFocus: Bool
    @State var input: String = ""
    @State private var isInputMode: Bool = false
    
    var body: some View {
        
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
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isInputMode = newValue
                            }
                        }
                }
                .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                .background(Color(uiColor: .systemGray6))
                .cornerRadius(7)
                
                Button(action: {
                    withAnimation {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isFocus = false
                            isInputMode = false
                        }
                    }
                }, label: {
                    Text("취소")
                })
                .transition(.move(edge: .trailing))
                .isHidden(hidden: !isInputMode, remove: true)
            }
        }
        .padding(.init(top: isInputMode ? 10 : 50, leading: 20, bottom: 0, trailing: 20))
    }
}

struct RecentListView: View {
    var body: some View {
        List {
            Section(header: Text("최근 검색어")
                .foregroundStyle(.black)
                .font(.system(size: 20).bold())) {
                    Text("test")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(uiColor: .systemBlue))
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    SearchView()
}
