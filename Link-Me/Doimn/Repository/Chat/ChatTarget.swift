//
//  ChatTarget.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 13/12/2023.
//

import Foundation
import Alamofire

enum ChatTarget: TargetType {
    case sendMessage(Parameters: ChatMessageRequestModel, fileModel: [MultiPartData])
    case chatRequests
}

extension ChatTarget {
    var path: String {
        switch self {
        case .sendMessage:
            return "/chat-request/send-message"
        case .chatRequests:
            return "/chat-requests"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .sendMessage, .chatRequests:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .sendMessage(let Parameters, let fileModel):
            return .multiPart(Parameters, fileModel)
        case .chatRequests:
            return .requestPlain
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .sendMessage, .chatRequests:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
    }
}
