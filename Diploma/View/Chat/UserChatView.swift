//
//  ChatLogView.swift
//  Diploma
//
//  Created by Артём Амаев on 21.02.24.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

struct UserChatView: View {
    let userId: String
    @ObservedObject var viewModel: UserChatViewModel
    
    init(userId: String) {
        self.userId = userId
        self.viewModel = .init(userId: userId)
    }
    
    var body: some View {
        VStack {
            messages
            
            chatBottomBar
        }
        .navigationTitle(viewModel.chatUser?.userName ?? "")
        .toolbar {
            if let image = viewModel.chatUser?.profilePictureURL {
                WebImage(url: URL(string: image))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .cornerRadius(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var messages: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                LazyVStack {
                    ForEach(viewModel.chatMessages) { message in
                        if message.fromId == Auth.auth().currentUser?.uid {
                            HStack {
                                Spacer()
                                HStack {
                                    Text(message.messageText)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        } else {
                            HStack {
                                HStack {
                                    Text(message.messageText)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)
                        }
                    }
                    
                }
                
                .onChange(of: viewModel.chatMessages.last) { oldMessage, newMessage in
                    if let newMessage = newMessage {
                        withAnimation {
                            scrollView.scrollTo(newMessage.id)
                        }
                    }
                }.onAppear {
                    if let lastMessage = viewModel.chatMessages.last {
                    scrollView.scrollTo(lastMessage.id)
                    }
                
                }
                
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
    }
    
    

    var chatBottomBar: some View {
        HStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 24))
                .foregroundColor(Color(.darkGray))
            TextField("Message", text: $viewModel.chatText)
            Button {
                Task {
                    await viewModel.sendMessage()
                }
            } label: {
                Image(systemName: "arrow.up.circle")
                    .font(.system(size: 24))
            }
        }
        .padding()
    }
}

