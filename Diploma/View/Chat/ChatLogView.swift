//
//  ChatLogView.swift
//  Diploma
//
//  Created by Артём Амаев on 21.02.24.
//

import SwiftUI
import Firebase

struct ChatLogView: View {
    let chatUser: User?
    
    @ObservedObject var viewModel: ChatViewModel
    
    init(chatUser: User?) {
        self.chatUser = chatUser
        self.viewModel = .init(chatUser: chatUser)
    }
    

    var body: some View {
        VStack {
            messages
            
            chatBottomBar
        }
        .navigationTitle(chatUser?.userName ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var messages: some View {
        ScrollView {
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

