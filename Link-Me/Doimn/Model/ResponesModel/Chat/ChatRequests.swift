//
//  ChatList.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/12/2023.
//

import Foundation

// MARK: - ChatRequestsData
struct ChatRequestsData: Codable {
    let currentPage: Int?
    let data: [ChatRequestItem]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let nextPageURL, path: String?
    let perPage: Int?
    let prevPageURL: String?
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
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - ChatRequestItem
struct ChatRequestItem: Codable {
    let id, firstUserID, secondUserID, isAccepted: Int?
    let isSent: Int? // New property
    let isSpecial: Int?
    let deleteFromFirstUser: Int? // New property
    let deleteFromSecondUser: Int? // New property
    let expireAt: String? // New property
    let isEnded, isCounted, unread, isBlocked: Int? // New properties
    let chatType: String? // New property
    let createdAt, updatedAt: String?
    let firstUser, secondUser: User?

    enum CodingKeys: String, CodingKey {
        case id
        case firstUserID = "first_user_id"
        case secondUserID = "second_user_id"
        case isAccepted = "is_accepted"
        case isSent = "is_sent" // New mapping
        case isSpecial = "is_special"
        case deleteFromFirstUser = "delete_from_first_user" // New mapping
        case deleteFromSecondUser = "delete_from_second_user" // New mapping
        case expireAt = "expire_at" // New mapping
        case isEnded = "is_ended" // New mapping
        case isCounted = "is_counted" // New mapping
        case unread // New mapping
        case isBlocked = "is_blocked" // New mapping
        case chatType = "chat_type" // New mapping
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstUser = "first_user"
        case secondUser = "second_user"
    }
}
