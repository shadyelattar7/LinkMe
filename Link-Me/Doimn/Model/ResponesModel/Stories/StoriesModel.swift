////
////  StoriesModel.swift
////  Link-Me
////
////  Created by Ahmed Nasr on 20/09/2023.
////
//
//import Foundation
//
//// MARK: - StoriesModel
//struct StoriesModel: Codable {
//    let status: Bool?
//    let code: Int?
//    let data: StoryDats?
//    let post: Post?
//}
//
//// MARK: - StoryDats
//struct StoryDats: Codable {
//    let currentPage: Int?
//    let data: [UserStoryData]?
//    let firstPageURL: String?
//    let from, lastPage: Int?
//    let lastPageURL: String?
//    let links: [Link]?
//    let path: String?
//    let perPage: Int?
//    let to, total: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case currentPage = "current_page"
//        case data
//        case firstPageURL = "first_page_url"
//        case from
//        case lastPage = "last_page"
//        case lastPageURL = "last_page_url"
//        case links
//        case path
//        case perPage = "per_page"
//        case to, total
//    }
//}
//
//// MARK: - UserStoryData
//struct UserStoryData: Codable {
//    let id: Int?
//    let name, email, birthDate, image: String?
//    let createdAt: String?
//    let gander: String?
//    let isOnline, isFollowing, isAvailable: Int?
//    let userName: String?
//    let imagePath: String?
//    let isProfileCompleted: Int?
//    let country: String?
//    let sentTickets, unreadTickets, canAddStory: Int?
//    let stories: [Story]?
//    
//    enum CodingKeys: String, CodingKey {
//        case id, name, email
//        case birthDate = "birth_date"
//        case image
//        case createdAt = "created_at"
//        case gander
//        case isOnline = "is_online"
//        case isFollowing = "is_following"
//        case isAvailable = "is_available"
//        case userName = "user_name"
//        case imagePath
//        case isProfileCompleted = "is_profile_completed"
//        case country
//        case sentTickets = "sent_tickets"
//        case unreadTickets = "unread_tickets"
//        case canAddStory, stories
//    }
//    
//    /// Initial value for example
//    ///
//    static let example = UserStoryData(id: nil, name: nil, email: nil, birthDate: nil, image: nil, createdAt: nil, gander: nil, isOnline: nil, isFollowing: nil, isAvailable: nil, userName: nil, imagePath: nil, isProfileCompleted: nil, country: nil, sentTickets: nil, unreadTickets: nil, canAddStory: nil, stories: nil)
//    
//}
//
//// MARK: - Story
//struct Story: Codable {
//    let id, userID: Int?
//    let file, expireAt, createdAt, updatedAt: String?
//    let description: String?
//    let video: String?
//    let likes: Int?
//    let comments: [Comments]?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case file
//        case expireAt = "expire_at"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case description, video, likes
//        case comments
//    }
//}
//
//// MARK: - Link
//struct Link: Codable {
//    let url: String?
//    let label: String?
//    let active: Bool?
//}
//
////MARK: - Comments
//struct Comments : Codable {
//    let id : Int?
//    let user_id : Int?
//    let story_id : Int?
//    let comment : String?
//    let created_at : String?
//    let updated_at : String?
//    let user : User?
//    
//    enum CodingKeys: String, CodingKey {
//        
//        case id = "id"
//        case user_id = "user_id"
//        case story_id = "story_id"
//        case comment = "comment"
//        case created_at = "created_at"
//        case updated_at = "updated_at"
//        case user = "user"
//    }
//}
//
//// MARK: - Post
//struct Post: Codable {
//    let currentPage: Int?
//    let data: [StoryElement]?
//    let firstPageURL: String?
//    let from, lastPage: Int?
//    let lastPageURL: String?
//    let links: [Link]?
//    let nextPageURL: Int?
//    let path: String?
//    let perPage: Int?
//    let prevPageURL: Int?
//    let to, total: Int?
//    
//    enum CodingKeys: String, CodingKey {
//        case currentPage = "current_page"
//        case data
//        case firstPageURL = "first_page_url"
//        case from
//        case lastPage = "last_page"
//        case lastPageURL = "last_page_url"
//        case links
//        case nextPageURL = "next_page_url"
//        case path
//        case perPage = "per_page"
//        case prevPageURL = "prev_page_url"
//        case to, total
//    }
//}
//
//// MARK: - StoryElement
//struct StoryElement: Codable {
//    let id, userID: Int?
//    let file, expireAt, createdAt, updatedAt: String?
//    let description: String?
//    let video: String?
//    let likes: Int?
//    let comments: [String]?
//    let user: User?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case file
//        case expireAt = "expire_at"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case description, video, likes, comments, user
//    }
//    
//    /// Initial value for example
//    ///
//    static let example = StoryElement(id: nil, userID: nil, file: nil, expireAt: nil, createdAt: nil, updatedAt: nil, description: nil, video: nil, likes: nil, comments: nil, user: nil)
//}
