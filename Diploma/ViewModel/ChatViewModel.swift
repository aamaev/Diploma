//
//  ChatViewModel.swift
//  Diploma
//
//  Created by Артём Амаев on 21.02.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
 
@MainActor
class ChatViewModel: ObservableObject {
    @Published var chatUser: User?
    @Published var chatText = ""
    @Published var chatMessages = [ChatMessage]()
        
    init(chatUser: User?) {
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    
    func fetchMessages() {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = chatUser?.id else { return }
            
        Firestore.firestore().collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                guard let snapshot = snapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                for change in snapshot.documentChanges {
                    if change.type == .added {
                        let data = change.document.data()
                        let toId = data["toId"] as? String ?? ""
                        let fromId = data["fromId"] as? String ?? ""
                        let text = data["text"] as? String ?? ""
                        let timestamp = data["timestamp"] as? String ?? ""
                        
                        let chatMessage = ChatMessage(id: change.document.documentID,
                                                      toId: toId,
                                                      fromId: fromId,
                                                      messageText: text,
                                                      timestamp: timestamp)
                        
                        self.chatMessages.append(chatMessage)
                    }
                }
            }
    }
    
    func sendMessage() async {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = chatUser?.id else { return }
    
        do {
            let document = Firestore.firestore().collection("messages").document(fromId).collection(toId).document()
            
            let messageData: [String: Any] =
                ["fromId": fromId,
                 "toId": toId,
                 "text": self.chatText,
                 "timestamp": FieldValue.serverTimestamp()]
            
            try await document.setData(messageData)
            
            let recipientMessageDocument = Firestore.firestore().collection("messages").document(toId).collection(fromId).document()
            
            try await recipientMessageDocument.setData(messageData)
            
            self.chatText = ""
        } catch {
            print("DEBUG: Failed to send message with error: \(error.localizedDescription)")
        }
    }
    
    func recentMessage() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let toId = chatUser?.id else { return }
        
        do {
            let document = Firestore.firestore().collection("recent_messages")
                                                .document(uid)
                                                .collection("messages")
                                                .document(toId)
            
            let data: [String : Any] = [
                "timestamp": Timestamp(),
                "text": self.chatText,
                "fromId": uid,
                "toId": toId,
                "userName": chatUser?.userName ?? ""
            ]
            
            try await document.setData(data)
            
        } catch {
            print("DEBUG: Failed to fetch recent messages with error: \(error.localizedDescription)")
        }
    }
        
}
