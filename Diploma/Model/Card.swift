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
    let color: Color
    
    init(title: String, words: [Word]) {
        self.title = title
        self.words = words
        self.color = Colors.randomElement()!
    }
    
    enum CodingKeys: CodingKey {
        case title
        case words
    }
}

let Colors: [Color] = [.teal, .pink, .indigo, .orange, .purple, .yellow, .green, .blue, .purple, .brown, .red]
