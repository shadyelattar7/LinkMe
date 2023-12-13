//
//  ChatMessage.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 13/12/2023.
//

import Foundation

enum ChatMessageType: String, Encodable {
    case text
    case file
}

enum ChatMessageMediaType: String, Encodable {
    case sound
    case image
}

struct ChatMessageRequestModel: Encodable {
    let chatId: String?
    let message: String?
    let type: String?
    let mediaType: String?
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case message, type
        case mediaType = "media_type"
    }
    
    init(chatId: String?, message: String?, type: String?, mediaType: String?) {
        self.chatId = chatId
        self.message = message
        self.type = type
        self.mediaType = mediaType
    }
}
