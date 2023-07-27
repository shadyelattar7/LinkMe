//
//  ForgetPassword.swift
//  Link-Me
//
//  Created by Al-attar on 25/05/2023.
//

import Foundation

struct ForgetPasswordRequestModel: Encodable{
    let email: String
    let code: String
    let password: String
    let confirmPassword: String

    
    enum CodingKeys: String, CodingKey{
        case email, code, password
        case confirmPassword = "confirm-password"
        
    }
}
