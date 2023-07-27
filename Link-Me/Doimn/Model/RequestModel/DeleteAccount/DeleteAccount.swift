//
//  DeleteAccount.swift
//  Link-Me
//
//  Created by Al-attar on 08/07/2023.
//

import Foundation

struct DeleteAccountRequestModel: Encodable{
    let reason: String
    let password: String
    
    enum CodingKeys: String, CodingKey{
        case reason, password
    }
}
