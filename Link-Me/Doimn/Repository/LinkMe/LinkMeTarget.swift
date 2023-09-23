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
}

extension LinkMeTarget: TargetType {
    var path: String {
        switch self {
        case .topUsers:
            return "/top-users"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .topUsers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .topUsers:
            return .requestPlain
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
