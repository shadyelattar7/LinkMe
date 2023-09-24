//
//  LinkMeViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

class LinkMeViewModel: BaseViewModel {
    
    // MARK: Properties

    private let linkMeApi: LinkMeAPIProtocol
    private let disposeBag = DisposeBag()

    // MARK: Outputs

    private var topUsers = BehaviorRelay<[TopUserData]>(value: [])
    var topUsersObservable: Observable<[TopUserData]> {
        return topUsers.asObservable()
    }

    private var errorMessage = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessage.asObservable()
    }
    
    func getUserModel(_ row: Int) -> TopUserData {
        return topUsers.value[row]
    }

    // MARK: Init

    init(linkMeApi: LinkMeAPIProtocol = LinkMeAPI()) {
        self.linkMeApi = linkMeApi
    }
}

// MARK: Fetch top users

extension LinkMeViewModel {
    func fetchTopUsers() {
        linkMeApi.fetchTopUsers().subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                guard let users = model.data else { return }
                self.topUsers.accept(users)
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
}
