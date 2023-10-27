//
//  RequestChat.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 27/10/2023.
//

import Foundation

// MARK: - RequestChatData
struct RequestChatData: Codable {
    let id, firstUserID, secondUserID, isAccepted: Int?
    let isSpecial: Int?
    let createdAt, updatedAt: String?
    let firstUser, secondUser: User?
    let messages: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstUserID = "first_user_id"
        case secondUserID = "second_user_id"
        case isAccepted = "is_accepted"
        case isSpecial = "is_special"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstUser = "first_user"
        case secondUser = "second_user"
        case messages
    }
}

