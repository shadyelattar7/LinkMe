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
    case chatRequests(name: String)
    case oneChat(Parameters: OneChatRequestModel)
    case deleteChat(parameters: DeleteChatRequestModel)
    case friends
    case chatAccept(parameters: ChatRequestAcceptModel)
    case chatRefuse(parameters: ChatRequestRefuseModel)
    case endChat(chatID: Int)
    case deleteChatForMe(parameters: DeleteChatForMeRequestModel)
    case deleteChatForEveryone(parameters: DeleteChatForEveryoneMeRequestModel)
    case reportUser(parameters: ReportUserRequestModel)
}

extension ChatTarget {
    var path: String {
        switch self {
        case .sendMessage:
            return "/chat-request/send-message"
        case .chatRequests(let name):
            return "/chat-requests?name=\(name)"
        case .oneChat:
            return "/one-chat"
        case .deleteChat:
            return "/chats/delete"
        case .friends:
            return "/friends"
        case .chatAccept:
            return "/chat-request/accept"
        case .chatRefuse:
            return "/chat-request/refuse"
        case .endChat(let chatID):
            return "/end-chat/\(chatID)"
        case .deleteChatForMe:
            return "/chat/hide-message"
        case .deleteChatForEveryone:
            return "/chat/delete-message"
        case .reportUser:
            return "users/report-user"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .sendMessage,
                .chatRequests,
                .oneChat,
                .deleteChat,
                .chatAccept,
                .chatRefuse,
                .endChat,
                .deleteChatForEveryone,
                .deleteChatForMe,
                .reportUser:
            return .post
        case .friends: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .sendMessage(let Parameters, let fileModel):
            return .multiPart(Parameters, fileModel)
        case .chatRequests, .friends, .endChat:
            return .requestPlain
        case .oneChat(let parameters):
            return .request(parameters)
        case .deleteChat(let parameters):
            return .request(parameters)
        case .chatAccept(let parameters):
            return .request(parameters)
        case .chatRefuse(let parameters):
            return .request(parameters)
        case .deleteChatForMe(let parameters):
            return .request(parameters)
        case .deleteChatForEveryone(let parameters):
            return .request(parameters)
        case .reportUser(let parameters):
            return .request(parameters)
        }
    }
    
    var headers: [String : String] {
        switch self {
        case .sendMessage,
                .chatRequests,
                .oneChat,
                .deleteChat,
                .friends,
                .chatAccept,
                .chatRefuse,
                .endChat,
                .deleteChatForMe,
                .deleteChatForEveryone,
                .reportUser:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
    }
}
