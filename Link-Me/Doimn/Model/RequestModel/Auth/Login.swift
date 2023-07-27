//
//  Login.swift
//  Link-Me
//
//  Created by Al-attar on 19/05/2023.
//

import Foundation

struct LoginRequestModel: Encodable{
    let email: String
    let password: String

    
    enum CodingKeys: String, CodingKey{
        case email, password
       
        
    }
}
