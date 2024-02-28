//
//  ChatMessage.swift
//  Diploma
//
//  Created by Артём Амаев on 22.02.24.
//

import Foundation

struct ChatMessage: Codable, Identifiable, Equatable {
    let id: String
    let toId: String
    let fromId: String
    let messageText: String
    let timestamp: String
}
