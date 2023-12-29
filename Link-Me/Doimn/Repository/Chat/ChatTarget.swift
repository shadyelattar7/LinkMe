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
    case oneChat(Parameters: OneChatRequestModel)
}

extension ChatTarget {
    var path: String {
        switch self {
        case .sendMessage:
            return "/chat-request/send-message"
        case .chatRequests:
            return "/chat-requests"
        case .oneChat:
            return "/one-chat"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .sendMessage, .chatRequests, .oneChat:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .sendMessage(let Parameters, let fileModel):
            return .multiPart(Parameters, fileModel)
        case .chatRequests:
            return .requestPlain
        case .oneChat(let parameters):
            return .request(parameters)
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .sendMessage, .chatRequests, .oneChat:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
    }
}
