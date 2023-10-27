//
//  FilterSearchViewModel.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class FilterSearchViewModel: BaseViewModel {
    
    // MARK: Properties
    
    let myAccountWorker: MyAccountWorkerProtocol
    let worker: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    var countries: BehaviorRelay<[Countries]> = .init(value: [])
    var numberOfDiamonds: BehaviorRelay<Int> = .init(value: 0)
    
    // MARK: Init
    
    init(worker: ProfileWorkerProtocol = ProfileWorker(),
         myAccountWorker: MyAccountWorkerProtocol = MyAccountWorker()) {
        self.worker = worker
        self.myAccountWorker = myAccountWorker
        super.init()
        self.fetchCountries()
        self.getMyAccountData()
    }
    
    // MARK: Outputs
    
    private var errorMessage: PublishSubject<String> = .init()
    var errorMessageObserver: Observable<String> {
        return errorMessage.asObserver()
    }
    
    var numberOfCountries: Int {
        return countries.value.count
    }
}


// MARK: Fetch Countries

extension FilterSearchViewModel {
    func fetchCountries() {
        worker.getCountries().subscribe(onNext:{ [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let model):
                self.countries.accept(model.data ?? [])
                
            case .failure(let error):
                let error = error.userInfo["NSLocalizedDescription"] as! String
                self.errorMessage.onNext(error)
            }
        }).disposed(by: disposedBag)
    }
}


// MARK: Fetch Diamonds

extension FilterSearchViewModel {
    private func getMyAccountData() {
        myAccountWorker.myAccount().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.numberOfDiamonds.accept(model.data?.diamonds ?? 0)
                
            case .failure(let error):
                let error = error.userInfo["NSLocalizedDescription"] as! String
                self.errorMessage.onNext(error)
            }
        }).disposed(by: disposedBag)
    }
}
