//
//  HomeView.swift
//  detaile
//
//  Created by Denislav Dimitrov on 14.02.25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: String = "Daily detaile"
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                DailyDetaileView(selectedTab: $selectedTab)
                    .tabItem { Label("Daily detaile", systemImage: "sparkles") }
                    .tag("Daily detaile")
                
                MoodboardView(selectedTab: $selectedTab)
                    .tabItem { Label("Moodboard", systemImage: "tshirt")}
                    .tag("Moodboard")
                    .badge(1)
                
                WardrobeView(selectedTab: $selectedTab)
                    .tabItem { Label("Wardrobe", systemImage: "cabinet") }
                    .tag("Wardrobe")
                
                AccountView(selectedTab: $selectedTab)
                    .tabItem { Label("Account", systemImage: "person.fill") }
                    .tag("Account")
            }
            .tint(.indigo)
            .onAppear {
                if #available(iOS 15.0, *) {
                    let appearance = UITabBarAppearance()
                    UITabBar.appearance().scrollEdgeAppearance = appearance
                }
            }
        }
    }
}

#Preview {
    MainView()
}
