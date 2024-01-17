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
    case deleteChat(parameters: DeleteChatRequestModel)
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
        case .deleteChat:
            return "/chats/delete"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .sendMessage, .chatRequests, .oneChat, .deleteChat:
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
        case .deleteChat(let parameters):
            return .request(parameters)
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .sendMessage, .chatRequests, .oneChat, .deleteChat:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
    }
}
