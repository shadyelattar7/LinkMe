//
//  MessageModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 18/11/2023.
//

import Foundation


struct MessageModel: Codable {
    let ReceiverID: String?
    let SenderID: String?
    let chatId: String?
    let messages: MessageContentModel?
    let timeStamp: Int64?
}

struct MessageContentModel: Codable {
    let content: String?
    let createdAt: String?
    let path: String?
    let receiverId: String?
    let senderId: String?
    let type: MessageType
}

enum MessageType: Codable {
    case text
    case image
    case audio
}
