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
    let isSpecial: Int?
    let createdAt, updatedAt: String?
    let firstUser, secondUser: User?
//    let message: JSONNull?
//    let messages: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id
        case firstUserID = "first_user_id"
        case secondUserID = "second_user_id"
        case isAccepted = "is_accepted"
        case isSpecial = "is_special"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstUser = "first_user"
        case secondUser = "second_user"
//        case message, messages
    }
}
