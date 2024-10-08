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
    case likeStory(Parameters: LikeStoryRequestModel)
    case comment(Parameters: AddCommentRequestModel)
    case removeComment(Parameters: RemoveCommentRequestModel)
    case blockUser(parameters: BlockUserRequestModel)
    case reportUser(parameters: ReportUserRequestModel)
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
        case .likeStory:
            return "/story/toggle-like"
        case .comment:
            return "/story/add-comment"
        case .removeComment:
            return "/story/delete-comment"
        case .blockUser:
            return "/users/block-user"
        case .reportUser:
            return "/users/report-user"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .addNewStory, .deleteStory, .reportStory, .blockUser:
            return .post
        case .fetchStories:
            return .get
        case .likeStory:
            return .post
        case .comment:
            return .post
        case .removeComment:
            return .post
        case .reportUser:
            return .post
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
        case .likeStory(let Parameters):
            return .request(Parameters)
        case .comment(let Parameters):
            return .request(Parameters)
        case .removeComment(let Parameters):
            return .request(Parameters)
        case .blockUser(let parameters):
            return .request(parameters)
        case .reportUser(let parameters):
            return .request(parameters)
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
