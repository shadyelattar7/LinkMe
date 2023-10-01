//
//  TopUsers.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 23/09/2023.
//

import Foundation

// MARK: - TopUserData

struct TopUserData: Codable {
    let users: [User]?
    let stars: [Star]?
    let diamonds: Int?
}

// MARK: - Star
struct Star: Codable {
    let id, diamonds: Int?
    let titleAr, titleEn: String?
    let hours: Double?
    let lang: String?

    enum CodingKeys: String, CodingKey {
        case id, diamonds
        case titleAr = "title_ar"
        case titleEn = "title_en"
        case hours
        case lang
    }
}

