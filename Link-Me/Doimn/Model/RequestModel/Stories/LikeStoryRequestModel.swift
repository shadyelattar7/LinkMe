//
//  LikeStoryRequestModel.swift
//  Link-Me
//
//  Created by Al-attar on 26/09/2023.
//

import Foundation

struct LikeStoryRequestModel: Encodable {
    let storyID: Int
    
    enum CodingKeys: String, CodingKey {
        case storyID = "story_id"
    }
}
