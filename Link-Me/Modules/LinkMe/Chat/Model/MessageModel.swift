//
//  MessageModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 18/11/2023.
//

import Foundation

struct ChatMessagePusherModel: Codable {
    let chat_id: Int?
    let user_id: Int?
    let user_name: String?
    let user_image: String?
    let message: String?
    let type: String? // text, file
    let media_type: String? // image, sound
    let file: String? // path of image or sound
    let created_at: String? // "2023-12-29T19:09:02.000000Z\"
}

struct MessageModel: Codable {
    let SenderID: String?
    let chatId: String?
    let messages: MessageContentModel?
}

struct MessageContentModel: Codable {
    let createdAt: String?
    let content: String?
    let path: String?
    let senderId: String?
    let type: MessageType
}

enum MessageType: Codable {
    case text
    case image
    case audio
}
