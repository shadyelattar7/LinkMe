//
//  OneChat.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 29/12/2023.
//

import Foundation


// MARK: - OneChatDate
struct OneChatDate: Codable {
    let currentPage: Int?
    let data: [OneChatItem]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL, path: String?
    let perPage: Int?
    let to, total: Int?

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case to, total
    }
}

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
    }
}
