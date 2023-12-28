//
//  RequestChatStateViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 04/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct ResponseData: Codable {
    let request_id: Int?
    let status: Int?
}

class RequestChatStateViewModel {
    
    // MARK: Properties
    
    private var requestModel: RequestChatRequestModel?
    private var worker: LinkMeAPIProtocol
    private let disposeBag = DisposeBag()
    private let pusherManager = PusherManager.shared
    private var chatID: Int?
    
    func updateRequestChatRequestModel(_ model: RequestChatRequestModel) {
        self.requestModel = model
    }
    
    var bindToResponseClosure: (() -> Void)?
    private var requestChatModel: RequestChatData? = nil {
        didSet {
            bindToResponseClosure?()
        }
    }
    
    var bindTosubscribeRequestClosure: ((Int) -> Void)?
    private var requestStatus: Int? = nil {
        didSet {
            bindTosubscribeRequestClosure?(requestStatus ?? 0)
        }
    }
    
    
    func getRequestChatResponse() -> RequestChatData? {
        return requestChatModel
    }
    
    private var errorMessage: PublishSubject<String> = .init()
    var errorMessageObserver: Observable<String> {
        return errorMessage.asObserver()
    }
    
    // MARK: Init
    
    init(worker: LinkMeAPIProtocol = LinkMeAPI()) {
        self.worker = worker
    }
    
    deinit {
        PusherManager.shared.disconnect()
    }
    
    //MARK: Private func
    private func subscribeRequest(id: Int) {
        pusherManager.subscribeToChannel(channelName: "request-\(id)", eventName: "request-updated") { event in
            let jsonString = event.data
            
            if let responseData: ResponseData = PusherManager.shared.parseJSON(jsonString: jsonString, type: ResponseData.self) {
                let requestId = responseData.request_id
                let status = responseData.status
                self.chatID = requestId
                self.requestStatus = responseData.status
                print("Request ID: \(requestId), Status: \(status)")
            }
        }
    }
    
    func getChatID() -> String {
        return "\(self.chatID ?? 0)"
    }
}

// MARK: Request chat

extension RequestChatStateViewModel {
    func requestChat() {
        
        guard let model = self.requestModel else { return }
        worker.requestChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
               // self.requestChatModel = data
                print("ID: \(data.id ?? 0)")
                self.subscribeRequest(id: data.id ?? 0)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
}
