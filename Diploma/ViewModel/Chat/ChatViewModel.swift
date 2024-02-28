//
//  ChatViewModel.swift
//  Diploma
//
//  Created by Артём Амаев on 24.02.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class ChatViewModel: ObservableObject {
    @Published var users: [User]?
    @Published var recentMessages = [RecentMessage]()
    
    init() {
        Task {
            await fetchUsers()
            fetchRecentMessages()
        }
    }
    
    func fetchUsers() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").getDocuments()
            
            let users = snapshot.documents.compactMap { document in
                try? document.data(as: User.self)
            }
            
            self.users = users.filter { $0.id != uid }
        } catch {
            print("DEBUG: Failed to fetch users with error: \(error.localizedDescription)")
        }
    }
    
    func fetchRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("recent_messages")
            .document(uid)
            .collection("messages")
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("DEBUG: Error fetching recent messages snapshot: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                for change in snapshot.documentChanges {
                    if change.type == .added {
                        let data = change.document.data()
                        
                        let docId = change.document.documentID
                        let text = data["text"] as? String ?? ""
                        let fromId = data["fromId"] as? String ?? ""
                        let toId = data["toId"] as? String ?? ""
                        let userName = data["userName"] as? String ?? ""
                        let profilePictureURL = data["profilePictureURL"] as? String ?? ""
                        let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                        
                        let recentMessage = RecentMessage(id: docId,
                                                          text: text,
                                                          fromId: fromId,
                                                          toId: toId,
                                                          userName: userName,
                                                          profilePictureURL: profilePictureURL,
                                                          timestamp: timestamp)
                       
                        if let index = self.recentMessages.firstIndex(where: { rm in
                            return rm.id == docId
                        }) {
                            self.recentMessages.remove(at: index)
                        }
                        
                        self.recentMessages.insert(recentMessage, at: 0)
                        
                        print(recentMessage)
                    }
                }
                
            }
        
    }
}
