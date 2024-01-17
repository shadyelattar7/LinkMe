//
//  DeleteChatSheetViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/01/2024.
//

import Foundation
import RxSwift
import RxCocoa

enum DeleteChatScreenState {
    case success
    case error(String)
}

class DeleteChatSheetViewModel: BaseViewModel {
    
    // MARK: Properties
    
    private let worker: ChatWorkerProtocol
    private let disposedBag = DisposeBag()
    
    // MARK: Inputs
    
    private let chatsID: [Int]
    
    // MARK: Outputs
    
    private var screenState: PublishSubject<DeleteChatScreenState> = .init()
    var screenStateObserver: Observable<DeleteChatScreenState> {
        return screenState.asObserver()
    }
    
    // MARK: Init
    
    init(chatsID: [Int], worker: ChatWorkerProtocol = ChatWorker()) {
        self.worker = worker
        self.chatsID = chatsID
    }
}

// MARK: Outputs

extension DeleteChatSheetViewModel {
    func getNumberOfChats()-> Int {
        return chatsID.count
    }
}


// MARK: delete chats

extension DeleteChatSheetViewModel {
    func deleteChats() {
        let model = DeleteChatRequestModel(chatId: chatsID)
        
        worker.deleteChat(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                if response.status == true {
                    self.screenState.onNext(.success)
                }
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.screenState.onNext(.error(errorMessage ?? ""))
            }
        }).disposed(by: disposedBag)
    }
}
