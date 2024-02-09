//
//  Question.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import Foundation

struct Question: Identifiable, Codable {
    var id: UUID = .init()
    var question: String
    var option: [String]
    var answer: String
    
    var tappedAnswer: String = ""
    
    enum CodingKeys: CodingKey {
        case question
        case option
        case answer
    }
}
