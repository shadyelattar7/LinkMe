//
//  Countries.swift
//  Link-Me
//
//  Created by Al-attar on 17/06/2023.
//

import Foundation

struct Countries : Codable {
    let id : Int?
    let country_enName : String?
    let country_arName : String?
    let lang : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case country_enName = "country_enName"
        case country_arName = "country_arName"
        case lang = "lang"
    }
}
