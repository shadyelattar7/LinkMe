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
}

extension ChatTarget {
    var path: String {
        switch self {
        case .sendMessage:
            return "/chat-request/send-message"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .sendMessage:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .sendMessage(let Parameters, let fileModel):
            return .multiPart(Parameters, fileModel)
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .sendMessage:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
    }
}
