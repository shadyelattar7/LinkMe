//
//  ReportStoryRequestModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import Foundation


struct ReportStoryRequestModel: Encodable {
    let storyID: Int
    let reason: String
    
    enum CodingKeys: String, CodingKey {
        case storyID = "story_id"
        case reason
    }
}
