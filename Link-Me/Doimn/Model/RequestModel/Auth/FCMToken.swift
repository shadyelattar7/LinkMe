//
//  FCMToken.swift
//  Link-Me
//
//  Created by Al-attar on 02/12/2023.
//

import Foundation

struct FCMTokenRequestModel: Encodable{
    let fcm_token: String

    enum CodingKeys: String, CodingKey{
        case fcm_token
    }
}
