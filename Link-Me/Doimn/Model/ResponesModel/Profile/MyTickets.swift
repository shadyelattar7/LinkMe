//
//  MyTickets.swift
//  Link-Me
//
//  Created by Al-attar on 29/06/2023.
//

import Foundation

struct BaseMyTickets : Codable {
    
    let status : Bool?
    let code : Int?
    let dats : Dats?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case code = "code"
        case dats = "dats"
    }
}

struct Dats : Codable {
    let current_page : Int?
    let data : [TicketsData]?
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


struct TicketsData : Codable {
    let id : Int?
    let email : String?
    let title : String?
    let description : String?
    let user_id : Int?
    let status : String?
    let created_at : String?
    let updated_at : String?
    let type : String?
    let is_read : Int?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case email = "email"
        case title = "title"
        case description = "description"
        case user_id = "user_id"
        case status = "status"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case type = "type"
        case is_read = "is_read"
    }
}

struct Links : Codable {
    let url : String?
    let label : String?
    let active : Bool?

    enum CodingKeys: String, CodingKey {

        case url = "url"
        case label = "label"
        case active = "active"
    }
}
