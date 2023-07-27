//
//  FeedbackRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 02/07/2023.
//

import Foundation

struct FeedbackRequestModel: Encodable{
    let email: String
    let title: String
    let description: String
    let type: String
    
    enum CodingKeys: String, CodingKey{
        case email, title, description, type
    }
}
