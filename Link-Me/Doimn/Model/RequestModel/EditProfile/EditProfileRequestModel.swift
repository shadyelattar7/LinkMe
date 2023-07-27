//
//  EditProfileRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 24/06/2023.
//

import Foundation

struct EditProfileRequestModel: Encodable{
    let email: String
    let name: String
    let username: String
    let birth_date: String
    let country_id: String
    let gander: String
    let bio: String
    
    enum CodingKeys: String, CodingKey{
        case email,name,username,birth_date, country_id,bio,gander
    }
}
