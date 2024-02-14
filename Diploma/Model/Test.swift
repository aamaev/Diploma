//
//  Test.swift
//  Diploma
//
//  Created by Артём Амаев on 11.02.24.
//

import Foundation

struct Test: Identifiable, Codable, Hashable {
    var id: UUID = .init()
    var rules: String
    var title: String
    var questions: [Question]
    
    enum CodingKeys: CodingKey {
        case rules
        case title
        case questions
    }
}
