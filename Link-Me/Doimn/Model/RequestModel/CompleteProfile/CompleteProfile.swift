//
//  CompleteProfile.swift
//  Link-Me
//
//  Created by Al-attar on 17/06/2023.
//

import Foundation
struct CompleteProfileRequestModel: Encodable{
    let country_id: Int
    let bio: String
    let gander: String

    
    enum CodingKeys: String, CodingKey{
        case country_id, bio, gander
    }
}
