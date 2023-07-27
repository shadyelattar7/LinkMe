//
//  Register.swift
//  Link-Me
//
//  Created by Al-attar on 18/05/2023.
//

import Foundation

struct RegisterRequestModel: Encodable{
    let email: String
    let code: String
    let name: String
    let password: String
    let confirmPassword: String
    let birth_date: String
    
    enum CodingKeys: String, CodingKey{
        case email, code, name, password, birth_date
        case confirmPassword = "confirm-password"
        
    }
}
