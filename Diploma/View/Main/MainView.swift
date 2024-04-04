//
//  MainView.swift
//  Diploma
//
//  Created by Артём Амаев on 7.02.24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Group {
                ChatView()
                    .tabItem {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                        Text("Chats")
                    }
                
                CardsListView()
                    .tabItem {
                        Image(systemName: "square.on.square")
                        Text("Cards")
                    }
                
                LeaderboardView()
                    .tabItem {
                        Image(systemName: "trophy.fill")
                        Text("Leaderboard")
                    }
                
                TestsView()
                    .tabItem {
                        Image(systemName: "book.fill")
                        Text("Tests")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

#Preview {
    MainView()
}






