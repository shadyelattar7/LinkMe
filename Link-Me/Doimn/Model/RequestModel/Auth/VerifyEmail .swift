//
//  LoginRequest.swift
//  Link-Me
//
//  Created by Al-attar on 16/05/2023.
//

import Foundation


struct VerifyEmailRequestModel: Encodable{
    let email: String

    
    enum CodingKeys: String, CodingKey{
        case email
        
    }
}


struct VerifyEmailForgetPasswordRequestModel: Encodable{
    let email: String

    
    enum CodingKeys: String, CodingKey{
        case email
    }
}
