//
//  RemoveCommentRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 28/09/2023.
//

import Foundation

struct RemoveCommentRequestModel: Encodable {
    let comment_id: Int
    
    enum CodingKeys: String, CodingKey {
        case comment_id
    }
}
