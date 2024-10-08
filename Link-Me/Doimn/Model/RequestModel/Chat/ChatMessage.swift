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
    case video
}

struct ChatMessageRequestModel: Encodable {
    let chatId: String?
    let message: String?
    let type: String?
    let mediaType: String?
    let oneTime: String?
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case message, type
        case mediaType = "media_type"
        case oneTime = "one_time"
    }
    
    init(chatId: String?, message: String?, type: String?, mediaType: String?, oneTime: String?) {
        self.chatId = chatId
        self.message = message
        self.type = type
        self.mediaType = mediaType
        self.oneTime = oneTime
    }
}
