//
//  RequestChatViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 05/10/2024.
//

import Foundation
import RxSwift
import RxCocoa

class RequestChatViewModel: BaseViewModel {
    
    // MARK:  proprites
    var chatID: String
    private let worker: ChatWorkerProtocol = ChatWorker()
    private let disposeBag = DisposeBag()
    var acceptChat: PublishSubject<ChatUserInfo> = .init()
    var refuseChat: PublishSubject<ChatUserInfo> = .init()
    
    init(chatID: String) {
        self.chatID = chatID
    }
    
    
    func acceptChatRequest() {
        let model = ChatRequestAcceptModel(requestId: Int(chatID))
        worker.acceptChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.acceptChat.onNext(data)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
            
        }).disposed(by: disposeBag)
    }
    
    func refuseChatRequest() {
        let model = ChatRequestRefuseModel(requestId: Int(chatID))
        worker.refuseChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard let data = model.data else { return }
                self.refuseChat.onNext(data)
            case .failure(let error):
                guard let errorMessage = error.userInfo["NSLocalizedDescription"] as? String else { return }
                print("errorMessage: \(errorMessage)")
            }
            
        }).disposed(by: disposeBag)
    }
}
