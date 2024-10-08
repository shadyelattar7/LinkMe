//
//  ChatRequestAcceptOrRefuse.swift
//  Link-Me
//
//  Created by Al-attar on 24/08/2024.
//

import Foundation

struct ChatRequestAcceptOrRefuse: Codable {
    let id : Int?
    let type : String?
    let first_user_id : Int?
    let second_user_id : Int?
    let is_accepted : Int?
    let is_sent : Int?
    let is_special : Int?
    let delete_from_first_user : Int?
    let delete_from_second_user : Int?
    let expire_at : String?
    let is_ended : Int?
    let is_counted : Int?
    let chat_type : String?
    let created_at : String?
    let updated_at : String?
    let unread : Int?
    let is_blocked : Int?
    let first_user, second_user : User?
//    let message : String?
//    let messages : [String]?
    let bookmarked : String?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case type = "type"
        case first_user_id = "first_user_id"
        case second_user_id = "second_user_id"
        case is_accepted = "is_accepted"
        case is_sent = "is_sent"
        case is_special = "is_special"
        case delete_from_first_user = "delete_from_first_user"
        case delete_from_second_user = "delete_from_second_user"
        case expire_at = "expire_at"
        case is_ended = "is_ended"
        case is_counted = "is_counted"
        case chat_type = "chat_type"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case unread = "unread"
        case is_blocked = "is_blocked"
        case first_user = "first_user"
        case second_user = "second_user"
//        case message = "message"
//        case messages = "messages"
        case bookmarked = "bookmarked"
    }
}
