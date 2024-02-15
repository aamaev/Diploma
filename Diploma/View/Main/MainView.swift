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
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Chats")
                }
            CardsView()
                .tabItem {
                    Image(systemName: "square.on.square")
                    Text("Cards")
                }
            
            NavigationView {
                TestsView()
            }
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
        .accentColor(.blue)
    }
}

#Preview {
    MainView()
}
