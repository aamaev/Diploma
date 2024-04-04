//
//  LeaderboardView.swift
//  Diploma
//
//  Created by Артём Амаев on 16.03.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct LeaderboardView: View {
    @ObservedObject var viewModel = LeaderboardViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(Array(viewModel.leaderboardUsers?
                                .enumerated()
                                .reversed()
                                .reversed() ?? []), id: \.offset) { index, user in
                    HStack {
                        Text("\(index + 1)")
                            .font(.headline.bold())
                        if let image = user.profilePictureURL {
                            WebImage(url: URL(string: image) ?? URL(string: "https://cdn-icons-png.flaticon.com/512/9308/9308008.png"))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .cornerRadius(25)
                                .overlay {
                                    Circle()
                                        .stroke(.secondary, lineWidth: 1.0)
                                }
                                .padding(3.5)
                        }
                        
                        if (index == 0) {
                            Text(user.userName)
                                .font(.headline.bold())
                                .foregroundStyle(.yellow.gradient)
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(.yellow.gradient)
                        } else if (index == 1) {
                            Text(user.userName)
                                .font(.headline.bold())
                                .foregroundStyle(.gray.gradient)
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(.gray.gradient)
                        } else if (index == 2) {
                            Text(user.userName)
                                .font(.headline.bold())
                                .foregroundStyle(.brown.gradient)
                            Image(systemName: "trophy.fill")
                                .foregroundStyle(.brown.gradient)
                        } else {
                            Text(user.userName)
                        }
                        
                        Spacer()
                        
                        Text("\(Int(user.progress))")
                            .font(.headline.bold())
                    }
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .inset(by: 5)
                            .stroke(.gray, lineWidth: 1)
                    )
                }
                
            }
            .padding(10)
            .navigationTitle("Leaderboard")
        }
    }
}

#Preview {
    LeaderboardView(viewModel: LeaderboardViewModel())
}
