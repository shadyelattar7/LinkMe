//
//  FCMTokenWorker.swift
//  Link-Me
//
//  Created by Al-attar on 02/12/2023.
//

import Foundation
import Alamofire


enum FCMTokenNetworking: TargetType {
    case sendFCMToken
}

extension FCMTokenNetworking {
    var path: String{
        switch self {
        case .sendFCMToken:
            return "/update-fcm-token?fcm_tokon=\(UDHelper.fcmToken)"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .sendFCMToken:
            return .post
        }
    }
    
    var task: Task{
        switch self{
        case .sendFCMToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .sendFCMToken:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
        
    }
}
