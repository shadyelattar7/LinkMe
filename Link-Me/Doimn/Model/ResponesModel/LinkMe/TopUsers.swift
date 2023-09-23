//
//  TopUsers.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 23/09/2023.
//

import Foundation


// MARK: - TopUserData
struct TopUserData: Codable {
    let id: Int?
    let name, email, birthDate, image: String?
//    let emailVerifiedAt: JSONNull?
    let createdAt: String?
    let countryID: Int?
    let gander: String?
    let bio: String?
    let isOnline, isFollowing, isAvailable: Int?
    let userName: String?
//    let reason: JSONNull?
    let imagePath: String?
    let isProfileCompleted: Int?
    let country: String?
    let sentTickets, unreadTickets, canAddStory: Int?
//    let follower: [JSONAny]?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case birthDate = "birth_date"
        case image
//        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case countryID = "country_id"
        case gander, bio
        case isOnline = "is_online"
        case isFollowing = "is_following"
        case isAvailable = "is_available"
        case userName = "user_name"
//        case reason
        case imagePath
        case isProfileCompleted = "is_profile_completed"
        case country
        case sentTickets = "sent_tickets"
        case unreadTickets = "unread_tickets"
        case canAddStory
//        case follower
    }
}
