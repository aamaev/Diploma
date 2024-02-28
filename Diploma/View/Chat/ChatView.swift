//
//  ChatView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI
import Foundation
import Firebase
import SDWebImageSwiftUI

struct ChatView: View {
    @ObservedObject private var viewModel = ChatViewModel() 
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if searchText.isEmpty {
                    recentMessages
                } else {
                    searchList
                }
            }
            .navigationTitle("Chats")
            .searchable(text: $searchText)
        }
        .navigationBarHidden(true)
    }
    
    var searchResults: [User] {
        if searchText.isEmpty {
            return viewModel.users ?? []
        } else {
            return (viewModel.users)?.filter{ $0.userName.localizedCaseInsensitiveContains(searchText) } ?? []
        }
    }
    
    var searchList: some View {
        List(searchResults) { user in
            NavigationLink {
                UserChatView(userId: user.id)
            } label: {
                HStack(spacing: 16) {
                    if let imageURL = user.profilePictureURL {
                        WebImage(url: URL(string: imageURL))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 44)
                                    .stroke(lineWidth: 1.0)
                            )
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 44)
                                    .stroke(lineWidth: 1.0)
                            )
                    }
                    Text(user.userName)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                Divider()
                    .padding(.vertical, 8)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    var recentMessages: some View {
        ScrollView {
            ForEach(viewModel.recentMessages) { recentMessage in
                if let user = viewModel.users!.first(where: { user in
                    return (user.id == recentMessage.fromId || user.id == recentMessage.toId)
                }) {
                    NavigationLink {
                        UserChatView(userId: user.id)
                    } label: {
                        HStack(spacing: 16) {
                            if let userImageURL = user.profilePictureURL {
                                WebImage(url: URL(string: userImageURL))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(25)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 44)
                                            .stroke(lineWidth: 1.0)
                                    )
                            } else {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 44)
                                            .stroke(lineWidth: 1.0)
                                    )
                            }
                            
                            VStack(alignment: .leading) {
                                Text(user.userName)
                                    .font(.system(size: 16, weight: .bold))
                                Text(recentMessage.text)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Text(timeFormatter(from: recentMessage.timestamp))
                                .font(.system(size: 14, weight: .semibold))
                        }
                        Divider()
                            .padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal)
        }

    }
}

#Preview {
    ChatView()
}

