//
//  SendMessageModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 13/12/2023.
//

import Foundation

// MARK: - SendMessageData
struct SendMessageData: Codable {
    let id, firstUserID, secondUserID, isAccepted: Int?
    let isSpecial: Int?
    let createdAt, updatedAt: String?
    let firstUser, secondUser: User?
    let message: ChatMessageRemoteModel?
    let messages: [ChatMessageRemoteModel]?

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
        case message, messages
    }
}


// MARK: - ChatMessageRemoteModel
struct ChatMessageRemoteModel: Codable {
    let id: Int?
    let message, type: String?
    let chatID, senderID, read: Int?
    let mediaType, mediaName: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, message, type
        case chatID = "chat_id"
        case senderID = "sender_id"
        case read
        case mediaType = "media_type"
        case mediaName = "media_name"
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
