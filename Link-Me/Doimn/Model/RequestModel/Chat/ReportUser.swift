//
//  ReportUser.swift
//  Link-Me
//
//  Created by Al-attar on 30/09/2024.
//

import Foundation

struct ReportUserRequestModel: Encodable {
    let friendID: Int?
    
    enum CodingKeys: String, CodingKey {
        case friendID = "friend_id"
    }
}
