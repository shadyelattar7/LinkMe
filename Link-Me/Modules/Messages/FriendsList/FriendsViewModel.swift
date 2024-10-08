//
//  FriendsViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 01/03/2024.
//

import Foundation
import RxSwift
import RxCocoa


class FriendsViewModel: BaseViewModel {
    
    // MARK: Properties
    
    private let worker: ChatWorkerProtocol
    private let disposedBag = DisposeBag()
    
    var friends = BehaviorRelay<[Friendship]>(value: [])
    
    private var errorMessage = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessage.asObservable()
    }
    
    // MARK: Init
    
    init(worker: ChatWorkerProtocol = ChatWorker()) {
        self.worker = worker
        super.init()
        self.fetchFriends()
    }
}

extension FriendsViewModel {
    private func fetchFriends() {  
        worker.friends().subscribe { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                friends.accept(model.data?.data ?? [])
            case .failure(let error):
                self.errorMessage.onNext(error.localizedDescription)
            }
        }.disposed(by: disposedBag)
    }
}
