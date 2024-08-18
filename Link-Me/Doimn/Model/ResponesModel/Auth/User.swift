//
//  User.swift
//  Link-Me
//
//  Created by Al-attar on 18/05/2023.
//

import Foundation

struct User : Codable {
    let id : Int?
    let name : String?
    let email : String?
    let birth_date : String?
    let image : String?
    let email_verified_at : String?
    let created_at : String?
    let country_id : Int?
    let gander : String?
    let bio : String?
    let is_online : Int?
    let is_following : Int?
    let is_available : Int?
    let user_name : String?
    let imagePath : String?
    let is_profile_completed : Int?
    let country : String?
    let sent_tickets : Int?
    let unread_tickets : Int?
    let canAddStory: Int?
    let diamonds: Int?
    let is_star: Int?
    let chat_id: Int?
    let is_blocked: Int?
    let links: Int?
    let likes: Int?
    var is_link: Int?
    var last_availablity: String?
    var blocks_number: Int?
    var can_see_links: Int?
    var can_see_followers: Int?
    var can_see_likes: Int?
    var is_subscribed: Int?
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case email = "email"
        case birth_date = "birth_date"
        case image = "image"
        case email_verified_at = "email_verified_at"
        case created_at = "created_at"
        case country_id = "country_id"
        case gander = "gander"
        case bio = "bio"
        case is_online = "is_online"
        case is_following = "is_following"
        case is_available = "is_available"
        case user_name = "user_name"
        case imagePath = "imagePath"
        case is_profile_completed = "is_profile_completed"
        case country = "country"
        case sent_tickets = "sent_tickets"
        case unread_tickets = "unread_tickets"
        case canAddStory = "canAddStory"
        case diamonds = "diamonds"
        case is_star = "is_star"
        case chat_id = "chat_id"
        case links = "links"
        case likes = "likes"
        case is_blocked = "is_blocked"
        case is_link = "is_link"
        case last_availablity = "last_availablity"
        case blocks_number = "blocks_number"
        case can_see_likes = "can_see_likes"
        case can_see_followers = "can_see_followers"
        case can_see_links = "can_see_links"
        case is_subscribed = "is_subscribed"
    }
    
}
