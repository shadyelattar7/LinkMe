//
//  OneChat.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 29/12/2023.
//

import Foundation


struct OneChatRequestModel: Encodable {
    let chatId: String?
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
    }
    
    init(chatId: String?) {
        self.chatId = chatId
    }
}
