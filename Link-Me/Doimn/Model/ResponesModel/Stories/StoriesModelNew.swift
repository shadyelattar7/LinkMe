//
//  StoriesModelNew.swift
//  Link-Me
//
//  Created by Ahmed_POMAC on 01/07/2024.
//

import Foundation
struct StoriesModel : Codable {
    let status : Bool?
    let code : Int?
    let data : StoryDats?
    let post : Post?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case code = "code"
        case data = "data"
        case post = "post"
    }
}
// MARK: - StoryDats
struct StoryDats: Codable {
    let currentPage: Int?
    let data: [UserStoryData]?
    let firstPageURL: String?
    let from, lastPage: Int?
    let lastPageURL: String?
    let links: [Link]?
    let path: String?
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
        case path
        case perPage = "per_page"
        case to, total
    }
}

// MARK: - UserStoryData
struct UserStoryData: Codable {
    let id: Int?
    let name, email, birthDate, image: String?
    let createdAt: String?
    let gander: String?
    let isOnline, isFollowing, isAvailable: Int?
    let userName: String?
    let imagePath: String?
    let isProfileCompleted: Int?
    let country: String?
    let sentTickets, unreadTickets, canAddStory: Int?
    var stories: [Stories]?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case birthDate = "birth_date"
        case image
        case createdAt = "created_at"
        case gander
        case isOnline = "is_online"
        case isFollowing = "is_following"
        case isAvailable = "is_available"
        case userName = "user_name"
        case imagePath
        case isProfileCompleted = "is_profile_completed"
        case country
        case sentTickets = "sent_tickets"
        case unreadTickets = "unread_tickets"
        case canAddStory, stories
    }

    /// Initial value for example
    ///
    static let example = UserStoryData(id: nil, name: nil, email: nil, birthDate: nil, image: nil, createdAt: nil, gander: nil, isOnline: nil, isFollowing: nil, isAvailable: nil, userName: nil, imagePath: nil, isProfileCompleted: nil, country: nil, sentTickets: nil, unreadTickets: nil, canAddStory: nil, stories: nil)

}

// MARK: - Story
struct Story: Codable {
    let id, userID: Int?
    let file, expireAt, createdAt, updatedAt: String?
    let description: String?
    let video: String?
    let likes: Int?
    let comments: [Comments]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case file
        case expireAt = "expire_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case description, video, likes
        case comments
    }
}
// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String?
    let active: Bool?
}

//MARK: - Comments
struct Comments : Codable {
    let id : Int?
    let user_id : Int?
    let story_id : Int?
    let comment : String?
    let created_at : String?
    let updated_at : String?
    let user : User?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case user_id = "user_id"
        case story_id = "story_id"
        case comment = "comment"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case user = "user"
    }
}
struct Post : Codable {
    let current_page : Int?
    let data : [StoryElement]?
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
struct StoryElement : Codable {
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
    let is_link : Int?
    let user_name : String?
    let reason : String?
    let type : String?
    let code : String?
    let fcm_token : String?
    let number_of_request : Int?
    let can_see_followers : Int?
    let can_see_likes : Int?
    let can_see_links : Int?
    let can_see_chats : Int?
    let is_active : Int?
    let last_user_id : Int?
    let last_availablity : String?
    let imagePath : String?
    let lastSeen : String?
    let likes : Int?
    let is_profile_completed : Int?
    let links : Int?
    let country : String?
    let sent_tickets : Int?
    let unread_tickets : Int?
    let canAddStory : Int?
    let followers : Int?
    let is_blocked : Int?
    let is_follower : Int?
    let stories : [Stories]?
    
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
        case is_link = "is_link"
        case user_name = "user_name"
        case reason = "reason"
        case type = "type"
        case code = "code"
        case fcm_token = "fcm_token"
        case number_of_request = "number_of_request"
        case can_see_followers = "can_see_followers"
        case can_see_likes = "can_see_likes"
        case can_see_links = "can_see_links"
        case can_see_chats = "can_see_chats"
        case is_active = "is_active"
        case last_user_id = "last_user_id"
        case last_availablity = "last_availablity"
        case imagePath = "imagePath"
        case lastSeen = "lastSeen"
        case likes = "likes"
        case is_profile_completed = "is_profile_completed"
        case links = "links"
        case country = "country"
        case sent_tickets = "sent_tickets"
        case unread_tickets = "unread_tickets"
        case canAddStory = "canAddStory"
        case followers = "followers"
        case is_blocked = "is_blocked"
        case is_follower = "is_follower"
        case stories = "stories"
    }
    static let example = StoryElement(id: nil, name: nil, email: nil, birth_date: nil, image: nil, email_verified_at: nil, created_at: nil, country_id: nil, gander: nil, bio: nil, is_online: nil, is_following: nil, is_available: nil, is_link: nil, user_name: nil, reason: nil, type: nil, code: nil, fcm_token: nil, number_of_request: nil, can_see_followers: nil, can_see_likes: nil, can_see_links: nil, can_see_chats: nil, is_active: nil, last_user_id: nil, last_availablity: nil, imagePath: nil, lastSeen: nil, likes: nil, is_profile_completed: nil, links: nil, country: nil, sent_tickets: nil, unread_tickets: nil, canAddStory: nil, followers: nil, is_blocked: nil, is_follower: nil, stories: nil)
}
struct Stories : Codable {
    let id : Int?
    let user_id : Int?
    let file : String?
    let expire_at : String?
    let created_at : String?
    let updated_at : String?
    let description : String?
    let is_active : Int?
    let video : String?
    let likes : Int?
    let comments : [Comments]?
    var is_like : Int?
    let is_read : Int?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case user_id = "user_id"
        case file = "file"
        case expire_at = "expire_at"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case description = "description"
        case is_active = "is_active"
        case video = "video"
        case likes = "likes"
        case comments = "comments"
        case is_like = "is_like"
        case is_read = "is_read"
    }
}
