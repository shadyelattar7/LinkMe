//
//  FriendResponseModel.swift
//  Link-Me
//
//  Created by Al-attar on 08/10/2024.
//

import Foundation

import Foundation

// MARK: - FriendsData
struct FriendsData: Codable {
    let currentPage: Int
    let data: [Friendship]
    let firstPageURL: String
    let from: Int
    let lastPage: Int
    let lastPageURL: String
    let links: [Links]
    let nextPageURL: String?
    let path: String
    let perPage: Int
    let prevPageURL: String?
    let to: Int
    let total: Int

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
        case to
        case total
    }
}

// MARK: - Friendship
struct Friendship: Codable {
    let id: Int
    let userID: Int
    let friendID: Int
    let isAccepted: Int
    let createdAt: String
    let updatedAt: String
    let deletedAt: String?
    let chatID: Int
    let friendObj: User
    let user: User
    let friend: User

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case friendID = "friend_id"
        case isAccepted = "is_accepted"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case chatID = "chat_id"
        case friendObj = "friend_obj"
        case user
        case friend
    }
}
