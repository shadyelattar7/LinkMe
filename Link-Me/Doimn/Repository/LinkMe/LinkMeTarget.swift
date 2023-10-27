//
//  LinkMeTarget.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 23/09/2023.
//

import Foundation
import Alamofire

enum LinkMeTarget {
    case topUsers
    case searchingForUsers(Parameters: SearchRequestModel?)
    case requestChat(Parameters: RequestChatRequestModel)
}

extension LinkMeTarget: TargetType {
    var path: String {
        switch self {
        case .topUsers:
            return "/top-users"
        case .searchingForUsers:
            return "/search"
        case .requestChat:
            return "/submit-request"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .topUsers:
            return .get
        case .searchingForUsers, .requestChat:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .topUsers:
            return .requestPlain
        case .searchingForUsers(let Parameters):
            return .request(Parameters)
        case .requestChat(let Parameters):
            return .request(Parameters)
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
