//
//  OneChat.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 29/12/2023.
//

import Foundation


struct OneChatRequestModel: Encodable {
    let chatId: String?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case type
    }
    
    init(
        chatId: String?,
        type: String?
    ) {
        self.chatId = chatId
        self.type = type
    }
}
