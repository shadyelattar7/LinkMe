//
//  ChangePasswordRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 25/06/2023.
//

import Foundation

struct ChangePasswordRequestModel: Encodable{
    let oldPassword: String
    let password: String
    let confirmPassword: String
   
    
    enum CodingKeys: String, CodingKey{
        case oldPassword = "old_password"
        case password
        case confirmPassword = "confirm-password"
    }
}


