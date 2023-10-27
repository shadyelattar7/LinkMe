//
//  RequestChatRequestModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 27/10/2023.
//

import Foundation


struct RequestChatRequestModel: Encodable {
    let userId: Int?
    let message: String?
    let isSpecial: Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case message
        case isSpecial = "is_special"
    }
}
