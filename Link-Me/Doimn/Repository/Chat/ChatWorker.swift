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
}


class ChatWorker: APIClient<ChatTarget>, ChatWorkerProtocol {
    
    func sendMessage(model: ChatMessageRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponseGen<SendMessageData>, NSError>> {
        self.performMultipartRequest(target: .sendMessage(Parameters: model, fileModel: fileModel))
    }
    
    func getChatRequests() -> Observable<Result<BaseResponseGen<ChatRequestsData>, NSError>> {
        self.performRequest(target: .chatRequests)
    }
}
