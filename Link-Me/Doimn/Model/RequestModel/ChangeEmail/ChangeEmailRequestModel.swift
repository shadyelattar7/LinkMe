//
//  ChangeEmailRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 26/06/2023.
//

import Foundation
struct ChangeEmailRequestModel: Encodable{
    let email: String
    
    enum CodingKeys: String, CodingKey{
        case email
    }
}


struct ConfirmUpdateEmailRequestModel: Encodable{
    let email: String
    let code: String
    enum CodingKeys: String, CodingKey{
        case email
        case code
    }
}
