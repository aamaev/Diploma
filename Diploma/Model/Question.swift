//
//  Question.swift
//  Diploma
//
//  Created by Артём Амаев on 8.02.24.
//

import Foundation

struct Question: Identifiable, Codable, Hashable {
    var id: UUID = .init()
    var question: String
    var options: [String]
    var answer: String
    
    var selectedAnswer: String? = nil
    
    enum CodingKeys: CodingKey {
        case question
        case options
        case answer
    }
}
