//
//  BlockUser.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 17/01/2024.
//

import Foundation


struct BlockUserRequestModel: Encodable {
    let userId: Int?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
