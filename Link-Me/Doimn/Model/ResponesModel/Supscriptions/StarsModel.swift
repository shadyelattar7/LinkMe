//
//  StarsModel.swift
//  Link-Me
//
//  Created by Al-attar on 27/10/2023.
//

import Foundation

struct StarsModel: Codable {
    let id, diamonds: Int?
    let titleAr, titleEn: String?
    let hours: Double?
    let createdAt, updatedAt: String?
    let lang: String?
    
    enum CodingKeys: String, CodingKey {
        case id, diamonds
        case titleAr = "title_ar"
        case titleEn = "title_en"
        case hours
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lang
    }
}
