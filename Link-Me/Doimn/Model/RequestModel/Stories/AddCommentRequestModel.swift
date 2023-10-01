//
//  AddCommentRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 28/09/2023.
//

import Foundation

struct AddCommentRequestModel: Encodable {
    let story_id: Int
    let comment: String
    
    enum CodingKeys: String, CodingKey {
        case story_id, comment
    }
}
