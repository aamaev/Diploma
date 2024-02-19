//
//  Card.swift
//  Diploma
//
//  Created by Артём Амаев on 17.02.24.
//

import Foundation

struct Card: Hashable, Equatable, Identifiable {
    var id: UUID = .init()
    var title: String
    var words: [Word]
    
    enum CodingKeys: CodingKey {
        case title
        case words
    }
}
