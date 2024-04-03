//
//  leaderboardUser.swift
//  Diploma
//
//  Created by Артём Амаев on 16.03.24.
//

import Foundation

struct LeaderboardUser: Codable, Equatable, Identifiable {
    var id: UUID = .init()
    let userName: String
    let progress: Double
    let profilePictureURL: String?
}
