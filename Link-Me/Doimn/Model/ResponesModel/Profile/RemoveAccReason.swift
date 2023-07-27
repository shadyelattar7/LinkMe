//
//  RemoveAccReason.swift
//  Link-Me
//
//  Created by Al-attar on 08/07/2023.
//

import Foundation

struct RemoveAccReason : Codable {
  
    let id : Int?
    let title_ar : String?
    let title_en : String?
    let created_at : String?
    let updated_at : String?
    let lang : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title_ar = "title_ar"
        case title_en = "title_en"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case lang = "lang"
    }
}
