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
    case topUsersRemaining
    case buyStarts(Parameters: buyStarsRequestModel)
    case oneUser(userID: Int)
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
        case .topUsersRemaining:
            return "/top-users/remaining"
        case .buyStarts:
            return "/supscription/buy-stars"
        case .oneUser(let userID):
            return "/one-user?user_id=\(userID)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .topUsers, .topUsersRemaining:
            return .get
        case .searchingForUsers, .requestChat, .buyStarts:
            return .post
        case .oneUser:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .topUsers, .topUsersRemaining, .oneUser:
            return .requestPlain
        case .searchingForUsers(let Parameters):
            return .request(Parameters)
        case .requestChat(let Parameters):
            return .request(Parameters)
        case .buyStarts(let Parameters):
            return .request(Parameters)
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
