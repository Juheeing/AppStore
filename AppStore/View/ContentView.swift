//
//  ContentView.swift
//  AppStore
//
//  Created by 김주희 on 9/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            BottomNaviView()
        }
    }
}

struct BottomNaviView: View {
    
    @State var selection: Int = 0
    
    var body: some View {
        
        TabView(selection: $selection) {
            TodayView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait")
                }
                .tag(0)
            GameView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "gamecontroller.fill")
                }
                .tag(1)
            AppView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "square.stack.3d.up.fill")
                }
                .tag(2)
            ArcadeView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "arcade.stick")
                }
                .tag(3)
            SearchView()
                .hiddenNavigationBarStyle()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag(4)
        }
        .accentColor(Color(uiColor: .systemBlue))
        .onAppear {
            UITabBar.appearance().backgroundColor = UIColor(Color(uiColor: .systemGray6))
            UITabBar.appearance().barTintColor = UIColor(Color(uiColor: .systemGray))
        }
    }
}

struct TodayView: View {
    var body: some View {
        Text("투데이")
    }
}

struct GameView: View {
    var body: some View {
        Text("게임")
    }
}

struct AppView: View {
    var body: some View {
        Text("앱")
    }
}

struct ArcadeView: View {
    var body: some View {
        Text("아케이드")
    }
}

#Preview {
    ContentView()
}
