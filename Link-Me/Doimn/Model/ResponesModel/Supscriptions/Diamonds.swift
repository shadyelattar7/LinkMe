//
//  Diamonds.swift
//  Link-Me
//
//  Created by Al-attar on 27/10/2023.
//

import Foundation

struct DiamondsModel: Codable {
    let id: Int?
    let type, titleAr, titleEn: String?
    let number: Int?
    let price: Double?
    let appleID: Int?
    let description, createdAt, updatedAt: String?
    let lang: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case titleAr = "title_ar"
        case titleEn = "title_en"
        case number, price, description
        case appleID = "apple_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case lang
    }
}
