//
//  Tab.swift
//  Diploma
//
//  Created by Артём Амаев on 3.04.24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case chats = "bubble.left.and.bubble.right.fill"
    case cards = "square.on.square"
    case leaderboard = "trophy.fill"
    case tests = "book.fill"
    case profile = "person.crop.circle"
    
    var title: String {
        switch self {
        case .chats:
            return "Chats"
        case .cards:
            return "Cards"
        case .leaderboard:
            return "Leaderboard"
        case .tests:
            return "Tests"
        case .profile:
            return "Profile"
        }
    }
}

struct AnimatedTab: Identifiable {
    var id: UUID = .init()
    var tab: Tab
    var isAnimating: Bool?
}
