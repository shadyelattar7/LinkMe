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
    
    func getChatRequests() -> Observable<Result<BaseResponseGen<ChatRequestsData>, NSError>>
    
    func oneChat(model: OneChatRequestModel) -> Observable<Result<BaseResponseGen<OneChatDate>, NSError>>
    
    func deleteChat(model: DeleteChatRequestModel) -> Observable<Result<BaseResponse, NSError>>
}


class ChatWorker: APIClient<ChatTarget>, ChatWorkerProtocol {
    
    func sendMessage(model: ChatMessageRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponseGen<SendMessageData>, NSError>> {
        self.performMultipartRequest(target: .sendMessage(Parameters: model, fileModel: fileModel))
    }
    
    func getChatRequests() -> Observable<Result<BaseResponseGen<ChatRequestsData>, NSError>> {
        self.performRequest(target: .chatRequests)
    }
    
    func oneChat(model: OneChatRequestModel) -> Observable<Result<BaseResponseGen<OneChatDate>, NSError>> {
        self.performRequest(target: .oneChat(Parameters: model), requestModel: model)
    }
    
    func deleteChat(model: DeleteChatRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .deleteChat(parameters: model), requestModel: model)
    }
}
