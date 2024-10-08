//
//  OneChat.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 29/12/2023.
//

import Foundation


// MARK: - OneChatDate
//struct OneChatDate: Codable {
//    let data: [OneChatItem]?
//    let chat: ChatUserInfo
//
//    enum CodingKeys: String, CodingKey {
//        case data
//        case chat
//    }
//}
//
// MARK: - OneChatItem
struct OneChatItem: Codable {
    let id: Int?
    let message: String?
    let type: String?
    let chatID, senderID, read: Int?
    let mediaType, mediaName: String?
    let isDeleted: Int?
    let createdAt, updatedAt: String?
    let filePath: String?
    let is_read: String?
    let one_time: Int?

    enum CodingKeys: String, CodingKey {
        case id, message, type
        case chatID = "chat_id"
        case senderID = "sender_id"
        case read
        case mediaType = "media_type"
        case mediaName = "media_name"
        case isDeleted = "is_deleted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case filePath
        case is_read
        case one_time
    }
}
//
//struct ChatUserInfo : Codable {
//    let id : Int?
//    let type : String?
//    let first_user_id : Int?
//    let second_user_id : Int?
//    let is_accepted : Int?
//    let is_sent : Int?
//    let is_special : Int?
//    let delete_from_first_user : Int?
//    let delete_from_second_user : Int?
//    let expire_at : String?
//    let is_ended : Int?
//    let is_counted : Int?
//    let chat_type : String?
//    let created_at : String?
//    let updated_at : String?
//    let unread : Int?
//    let is_blocked : Int?
//    let first_user, second_user : User?
//    let message : String?
//    let messages : [String]?
//    let bookmarked : String?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case type = "type"
//        case first_user_id = "first_user_id"
//        case second_user_id = "second_user_id"
//        case is_accepted = "is_accepted"
//        case is_sent = "is_sent"
//        case is_special = "is_special"
//        case delete_from_first_user = "delete_from_first_user"
//        case delete_from_second_user = "delete_from_second_user"
//        case expire_at = "expire_at"
//        case is_ended = "is_ended"
//        case is_counted = "is_counted"
//        case chat_type = "chat_type"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//        case unread = "unread"
//        case is_blocked = "is_blocked"
//        case first_user = "first_user"
//        case second_user = "second_user"
//        case message = "message"
//        case messages = "messages"
//        case bookmarked = "bookmarked"
//    }
//
//}



struct BaseOneChat : Codable {
    let status : Bool?
    let code : Int?
    let data : OneChatData?
    let chat : ChatUserInfo?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case code = "code"
        case data = "data"
        case chat = "chat"
    }
}

struct OneChatData : Codable {
    let current_page : Int?
    let data : [OneChatItem]?
    let first_page_url : String?
    let from : Int?
    let last_page : Int?
    let last_page_url : String?
    let links : [Links]?
    let next_page_url : String?
    let path : String?
    let per_page : Int?
    let prev_page_url : String?
    let to : Int?
    let total : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case current_page = "current_page"
        case data = "data"
        case first_page_url = "first_page_url"
        case from = "from"
        case last_page = "last_page"
        case last_page_url = "last_page_url"
        case links = "links"
        case next_page_url = "next_page_url"
        case path = "path"
        case per_page = "per_page"
        case prev_page_url = "prev_page_url"
        case to = "to"
        case total = "total"
    }
}

struct ChatUserInfo : Codable {
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
    let first_user : User?
    let second_user : User?
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
