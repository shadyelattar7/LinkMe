//
//  DeleteChat.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 17/01/2024.
//

import Foundation


struct DeleteChatRequestModel: Encodable {
    let chatId: [Int]?
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
    }
}
