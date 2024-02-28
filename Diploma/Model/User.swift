//
//  User.swift
//  Diploma
//
//  Created by Артём Амаев on 7.02.24.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let userName: String
    let email: String
    var profilePictureURL: String?
    
    enum CodingKeys: CodingKey {
        case id
        case userName
        case email
        case profilePictureURL
    }
}
