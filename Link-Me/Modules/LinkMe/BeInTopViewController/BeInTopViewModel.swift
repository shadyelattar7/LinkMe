//
//  BeInTopViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 28/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class BeInTopViewModel {
 
    // MARK: Properties
    
    private var worker: LinkMeAPIProtocol
    private let disposeBag = DisposeBag()
    private var starPriceId: Int?
    
    // MARK: Inputs
    
    func updateStarPriceId(_ id: Int) {
        starPriceId = id
        self.buyStars()
    }
    
    // MARK: Outputs
    
    var onRemainingChange: (() -> Void)?
    private var remaining: Double? = 12.0 {
        didSet {
            onRemainingChange?()
        }
    }
    
    func getRemaining() -> Double? {
        return remaining
    }
    
    var onSuccessToBeInTop: (() -> Void)?
    private var onSuccess: Bool = false {
        didSet {
            onSuccessToBeInTop?()
        }
    }
    
    private var errorMessage: PublishSubject<String> = .init()
    var errorMessageObserver: Observable<String> {
        return errorMessage.asObserver()
    }
    
    // MARK: Init
    
    init( worker: LinkMeAPIProtocol = LinkMeAPI()) {
        self.worker = worker
        self.fetchTopUsersRemaining()
    }
}

// MARK: Searching for users

extension BeInTopViewModel {
    private func fetchTopUsersRemaining() {
        worker.fetchTopUsersRemaining().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                self.remaining = model.data
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
}


// MARK: Buy stars

extension BeInTopViewModel {
    private func buyStars() {
        guard let id = self.starPriceId else { return }
        let model = buyStarsRequestModel(starPriceId: id)
        worker.buyStars(model: model).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let model):
                if let error = model.message {
                    self.errorMessage.onNext(error)
                } else {
                    // TODO: - Need to handle if you can choose to be in top.
                    self.onSuccess = true
                }
                
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String
                self.errorMessage.onNext(errorMessage ?? "")
            }
            
        }).disposed(by: disposeBag)
    }
}
