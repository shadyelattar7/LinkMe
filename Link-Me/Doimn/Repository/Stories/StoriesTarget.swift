//
//  StoriesTarget.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/09/2023.
//

import Foundation
import Alamofire

enum StoriesTarget {
    case addNewStory(Parameters: AddNewStoryRequestModel, fileModel: [MultiPartData])
    case fetchStories
}

extension StoriesTarget: TargetType {
    var path: String {
        switch self {
        case .addNewStory:
            return "/story/add"
        case .fetchStories:
            return "/story/all"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .addNewStory:
            return .post
        case .fetchStories:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .addNewStory(let Parameters, let fileModel):
            return .multiPart(Parameters, fileModel)
        case .fetchStories:
            return .requestPlain
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
