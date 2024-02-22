//
//  ChatView.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class UsersListViewModel: ObservableObject {
    @Published var users: [User]?
    
    init() {
        Task {
            await fetchUsers()
        }
    }
    
    func fetchUsers() async {
        do {
            let snapshot = try await Firestore.firestore().collection("users").getDocuments()
            
            let users = snapshot.documents.compactMap { document in
                try? document.data(as: User.self)
            }
            
            self.users = users
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error.localizedDescription)")
        }
    }
    
    
}


struct ChatView: View {
    @ObservedObject private var viewModel = UsersListViewModel() 
    
    @State var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ForEach(searchResults, id: \.id) { user in
                        NavigationLink {
                            ChatLogView(chatUser: user)
                        } label: {
                            HStack(spacing: 16) {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 32))
                                    .padding(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 44)
                                            .stroke(lineWidth: 1.0)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(user.userName)
                                        .font(.system(size: 16, weight: .bold))
                                    Text("Message send to user")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text("22d")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            Divider()
                                .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
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
            return (viewModel.users ?? []).filter{ $0.userName.contains(searchText) }
        }
    }
}

