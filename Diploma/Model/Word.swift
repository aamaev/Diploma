//
//  Word.swift
//  Diploma
//
//  Created by Артём Амаев on 17.02.24.
//

import Foundation

struct Word: Identifiable, Hashable, Codable {
    var id: UUID = .init()
    var transcription: String
    var translate: String
    var word: String
    
    enum CodingKeys: CodingKey {
        case transcription
        case translate
        case word
    }
}
