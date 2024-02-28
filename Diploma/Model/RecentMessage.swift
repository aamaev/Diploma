//
//  RecentMessage.swift
//  Diploma
//
//  Created by Артём Амаев on 27.02.24.
//

import Foundation
import Firebase

struct RecentMessage: Codable, Identifiable, Equatable {
    let id: String
    let text: String
    let fromId: String
    let toId: String
    let userName: String
    let profilePictureURL: String
    let timestamp: Timestamp
}
