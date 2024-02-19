//
//  Test.swift
//  Diploma
//
//  Created by Артём Амаев on 11.02.24.
//

import Foundation

struct Test: Decodable, Hashable, Identifiable {
    var id: String
    var rules: String
    var title: String
    var questions: [Question]
    
    enum CodingKeys: CodingKey {
        case id
        case rules
        case title
        case questions
    }
}
