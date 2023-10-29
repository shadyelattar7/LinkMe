//
//  SubscribeTarget.swift
//  Link-Me
//
//  Created by Al-attar on 01/10/2023.
//

import Foundation
import Alamofire

enum SubscribeTarget {
    case supscriptionSubscribe(Parameters: SupscriptionSubscribeRequestModel)
}

extension SubscribeTarget: TargetType {
    var path: String {
        switch self {
        case .supscriptionSubscribe:
            return "/supscription/subscribe"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .supscriptionSubscribe:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .supscriptionSubscribe(let Parameters):
            return .request(Parameters)
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
