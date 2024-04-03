//
//  LeaderboardViewModel.swift
//  Diploma
//
//  Created by Артём Амаев on 16.03.24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class LeaderboardViewModel: ObservableObject {
    @Published var leaderboardUsers: [LeaderboardUser]?
    
    init() {
        Task {
            await fetchLeaderboardUsers()
        }
    }
    
    func fetchLeaderboardUsers() async {
        do {
            let snapshot = try await Firestore.firestore().collection("users").getDocuments()
            var leaderboardUsers = [LeaderboardUser]()
            
            for document in snapshot.documents {
                let leaderboardDocument = document.data()
                let userName = leaderboardDocument["userName"] as? String ?? ""
                let progress = leaderboardDocument["progress"] as? Double ?? 0.0
                let profilePictureURL = leaderboardDocument["profilePictureURL"] as? String ?? ""
                
                let leaderboardUser = LeaderboardUser(userName: userName,
                                                      progress: progress,
                                                      profilePictureURL: profilePictureURL)
                
                leaderboardUsers.append(leaderboardUser)
            }
            
            self.leaderboardUsers = leaderboardUsers.sorted(by: { $0.progress > $1.progress } )
        } catch {
            print("DEBUG: Failed to fetch leaderboard users with error: \(error.localizedDescription)")
        }
    }
}
