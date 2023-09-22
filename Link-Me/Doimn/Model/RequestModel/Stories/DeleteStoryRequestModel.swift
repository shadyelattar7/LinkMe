//
//  DeleteStory.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import Foundation

struct DeleteStoryRequestModel: Encodable {
    let storyID: Int
    
    enum CodingKeys: String, CodingKey {
        case storyID = "story_id"
    }
}
