//
//  VerifyCode.swift
//  Link-Me
//
//  Created by Al-attar on 18/05/2023.
//

import Foundation

struct VerifyCodeRequestModel: Encodable{
    let email: String
    let code: String
    
    enum CodingKeys: String, CodingKey{
        case email, code
        
    }
}
