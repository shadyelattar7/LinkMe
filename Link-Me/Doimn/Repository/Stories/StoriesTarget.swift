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
    case deleteStory(Parameters: DeleteStoryRequestModel)
    case reportStory(Parameters: ReportStoryRequestModel)
}

extension StoriesTarget: TargetType {
    var path: String {
        switch self {
        case .addNewStory:
            return "/story/add"
        case .fetchStories:
            return "/story/all"
        case .deleteStory:
            return "/story/delete"
        case .reportStory:
            return "/story/report"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .addNewStory, .deleteStory, .reportStory:
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
        case .deleteStory(let Parameters):
            return .request(Parameters)
        case .reportStory(let parameters):
            return .request(parameters)
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
