//
//  Card.swift
//  Diploma
//
//  Created by Артём Амаев on 17.02.24.
//

import Foundation
import SwiftUI

struct Card: Hashable, Equatable, Identifiable {
    var id: UUID = .init()
    var title: String
    var words: [Word]
    var color: Color
    
    enum CodingKeys: CodingKey {
        case title
        case words
        case cardColor
    }
}


extension Color {
    static func colorFromString(_ name: String) -> Color {
        switch name {
        case "yellow":
            return Color.yellow
        case "green":
            return Color.green
        case "teal":
            return Color.teal
        case "indigo":
            return Color.indigo
        case "orange":
            return Color.orange
        case "purple":
            return Color.purple
        case "brown":
            return Color.brown
        case "red":
            return Color.red
        default:
            return Color.accentColor
        }
    }
}

