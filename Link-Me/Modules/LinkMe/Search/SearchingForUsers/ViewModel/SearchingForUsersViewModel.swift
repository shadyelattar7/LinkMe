//
//  SearchingForUsersViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class SearchingForUsersViewModel: BaseViewModel {
    
    // MARK: Properties
     
    private let requestModel: SearchRequestModel?
    private let worker: LinkMeAPIProtocol
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(requestModel: SearchRequestModel?, worker: LinkMeAPIProtocol = LinkMeAPI()) {
        self.requestModel = requestModel
        self.worker = worker
        super.init()
        self.searchingForUsers()
    }
    
    // MARK: Outputs
    
    private var errorMessage: PublishSubject<String> = .init()
    var errorMessageObserver: Observable<String> {
        return errorMessage.asObserver()
    }
}

// MARK: Searching for users

extension SearchingForUsersViewModel {
    private func searchingForUsers() {
        print("searchingForUsers model", self.requestModel)
        worker.searchingForUsers(model: requestModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                // TODO: - Need to handle when request success.
                print("search request model", model)
                
            case .failure(let error):
                print("error", error)
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
                
        }).disposed(by: disposeBag)
    }
}
