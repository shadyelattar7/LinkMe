//
//  MessageListViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/12/2023.
//

import Foundation
import RxSwift
import RxCocoa

class MessageListViewModel: BaseViewModel {
    
    // MARK:  proprites
    
    private let worker: ChatWorkerProtocol = ChatWorker()
    private let disposeBag = DisposeBag()
    
    private var errorMessage = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessage.asObservable()
    }
    
    var onReloadTableViewClosure: (() -> Void) = { }
    private var data: [ChatRequestItem] = [] {
        didSet {
            onReloadTableViewClosure()
        }
    }
    
    var numberOfCells: Int {
        return data.count
    }
   
    func getItemCell(indexPath: IndexPath) -> ChatRequestItem {
        return data[indexPath.row]
    }
    
    func getListOfData()-> [ChatRequestItem] {
        return data
    }
    
    // MARK: Get chat requests
    
    func getChatRequests() {
        worker.getChatRequests().subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                self.data = model.data?.data ?? []

            case .failure(let error):
                self.errorMessage.onNext(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
}
