//
//  ChatRequest.swift
//  Link-Me
//
//  Created by Al-attar on 24/08/2024.
//

import Foundation

struct ChatRequestAcceptModel: Encodable {
    let requestId: Int?
    
    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
    }
}

struct ChatRequestRefuseModel: Encodable {
    let requestId: Int?
    
    enum CodingKeys: String, CodingKey {
        case requestId = "request_id"
    }
}
