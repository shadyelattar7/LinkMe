//
//  StoriesTarget.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/09/2023.
//

import Foundation
import Alamofire

enum StoriesTarget {
    case addNewStory (Parameters: AddNewStoryRequestModel, fileModel: [MultiPartData])
}

extension StoriesTarget: TargetType {
    var path: String {
        switch self {
        case .addNewStory:
            return "/story/add"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .addNewStory:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .addNewStory(let Parameters, let fileModel):
            return .multiPart(Parameters, fileModel)
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
