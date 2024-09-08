//
//  ContentView.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var global = Global()
    
    var body: some View {
        ZStack {
            BottomNaviView()
            IndicatorView(color: .gray).isHidden(hidden: !global.isLoading, remove: false)
        }
        .environmentObject(global)
    }
}

struct BottomNaviView: View {
    
    @State var selection: Int = 4
    
    var body: some View {
        
        TabView(selection: $selection) {
            TodayView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text("투데이")
                }
                .tag(0)
            GameView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                    Text("게임")
                }
                .tag(1)
            AppView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "square.stack.3d.up.fill")
                    Text("앱")
                }
                .tag(2)
            ArcadeView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "dpad")
                    Text("아케이드")
                }
                .tag(3)
            SearchView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("검색")
                }
                .tag(4)
        }
        .accentColor(Color(uiColor: .systemBlue))
        .onAppear {
            let appearance = UITabBarAppearance()
            UITabBar.appearance().scrollEdgeAppearance = appearance
            UITabBar.appearance().backgroundColor = UIColor(Color(uiColor: .systemGray6))
            UITabBar.appearance().barTintColor = UIColor(Color(uiColor: .systemGray))
        }
    }
}

struct IndicatorView: View {
    
    var color: Color
    
    var body: some View {
        ProgressView()
            .scaleEffect(2.0, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            
    }
}

struct TodayView: View {
    var body: some View {
        VStack {
            TopTitleView(title: "투데이", date: Date())
            Spacer()
        }
        .padding(.init(top: 50, leading: 20, bottom: 0, trailing: 20))
    }
}

struct GameView: View {
    var body: some View {
        VStack {
            TopTitleView(title: "게임")
            Spacer()
        }
        .padding(.init(top: 50, leading: 20, bottom: 0, trailing: 20))
    }
}

struct AppView: View {
    var body: some View {
        VStack {
            TopTitleView(title: "앱")
            Spacer()
        }
        .padding(.init(top: 50, leading: 20, bottom: 0, trailing: 20))
    }
}

struct ArcadeView: View {
    var body: some View {
        VStack {
            TopTitleView(title: "아케이드")
            Spacer()
        }
        .padding(.init(top: 50, leading: 20, bottom: 0, trailing: 20))
    }
}

#Preview {
    ContentView()
}
