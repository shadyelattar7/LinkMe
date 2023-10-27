//
//  RequestChatStateViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 04/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class RequestChatStateViewModel {
    
    // MARK: Properties
    
    private var requestModel: RequestChatRequestModel?
    private var worker: LinkMeAPIProtocol
    private let disposeBag = DisposeBag()
    
    func updateRequestChatRequestModel(_ model: RequestChatRequestModel) {
        self.requestModel = model
    }
    
    var bindToResponseClosure: (() -> Void)?
    private var requestChatModel: RequestChatData? = nil {
        didSet {
            bindToResponseClosure?()
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
                self.requestChatModel = data

            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
}
