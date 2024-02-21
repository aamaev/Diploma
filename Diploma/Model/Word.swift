//
//  Word.swift
//  Diploma
//
//  Created by Артём Амаев on 17.02.24.
//

import Foundation

struct Word: Hashable, Identifiable, Decodable {
    var id: UUID = .init()
    var transcription: String
    var translate: String
    var word: String
    var usage: [String]
    
    enum CodingKeys: CodingKey {
        case transcription
        case translate
        case word
        case usage
    }
}
