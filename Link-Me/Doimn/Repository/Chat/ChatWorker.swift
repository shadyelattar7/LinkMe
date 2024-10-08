//
//  ChatWorker.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 13/12/2023.
//

import Foundation
import RxSwift

protocol ChatWorkerProtocol {

    func sendMessage(model: ChatMessageRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponseGen<SendMessageData>, NSError>>
    
    func getChatRequests(name: String) -> Observable<Result<BaseResponseGen<ChatRequestsData>, NSError>>
    
    func oneChat(model: OneChatRequestModel) -> Observable<Result<BaseOneChat, NSError>>
    
    func deleteChat(model: DeleteChatRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    func friends() -> Observable<Result<BaseResponseGen<FriendsData>, NSError>>
    
    func acceptChat(model: ChatRequestAcceptModel) -> Observable<Result<BaseResponseGen<ChatUserInfo>, NSError>>

    func refuseChat(model: ChatRequestRefuseModel) -> Observable<Result<BaseResponseGen<ChatUserInfo>, NSError>>
    
    func endChat(chatID: Int) -> Observable<Result<BaseResponse, NSError>>
    
    func deleteChatForMe(model: DeleteChatForMeRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    func deleteChatForEveryone(model: DeleteChatForEveryoneMeRequestModel) -> Observable<Result<BaseResponse, NSError>>
}


class ChatWorker: APIClient<ChatTarget>, ChatWorkerProtocol {
   
    func sendMessage(model: ChatMessageRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponseGen<SendMessageData>, NSError>> {
        self.performMultipartRequest(target: .sendMessage(Parameters: model, fileModel: fileModel))
    }
    
    func getChatRequests(name: String) -> Observable<Result<BaseResponseGen<ChatRequestsData>, NSError>> {
        self.performRequest(target: .chatRequests(name: name))
    }
    
    func oneChat(model: OneChatRequestModel) -> Observable<Result<BaseOneChat, NSError>> {
        self.performRequest(target: .oneChat(Parameters: model), requestModel: model)
    }
    
    func deleteChat(model: DeleteChatRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .deleteChat(parameters: model), requestModel: model)
    }
    
    func friends() -> Observable<Result<BaseResponseGen<FriendsData>, NSError>> {
        self.performRequest(target: .friends)
    }
    
    func acceptChat(model: ChatRequestAcceptModel) -> Observable<Result<BaseResponseGen<ChatUserInfo>, NSError>> {
        self.performRequest(target: .chatAccept(parameters: model), requestModel: model)
    }
    
    func refuseChat(model: ChatRequestRefuseModel) -> Observable<Result<BaseResponseGen<ChatUserInfo>, NSError>> {
        self.performRequest(target: .chatRefuse(parameters: model), requestModel: model)
    }
    
    func endChat(chatID: Int) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .endChat(chatID: chatID))
    }
    
    func deleteChatForMe(model: DeleteChatForMeRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .deleteChatForMe(parameters: model), requestModel: model)
    }
    
    func deleteChatForEveryone(model: DeleteChatForEveryoneMeRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .deleteChatForEveryone(parameters: model), requestModel: model)
    }
}
