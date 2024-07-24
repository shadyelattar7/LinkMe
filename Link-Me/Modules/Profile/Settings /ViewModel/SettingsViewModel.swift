//
//  SettingsViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 20/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - ViewController -> ViewModel
protocol SettingsInputs {
    func changeOnline(view: UIView)
}

// MARK: - ViewController <- ViewModel
protocol SettingsOutputs {
    var onlineStatus: BehaviorRelay<Bool> { get }
}

class SettingsViewModel: BaseViewModel,SettingsOutputs,SettingsInputs {

    // MARK: - Properties
   
    let disposeBag = DisposeBag()
    var onlineStatus: BehaviorRelay<Bool> = .init(value: false)
    var onlineAvailable: BehaviorRelay<Bool> = .init(value: false)
    let changeOnlineWorker: ProfileWorkerProtocol
    init(changeOnlineWorker: ProfileWorkerProtocol) {
        self.changeOnlineWorker = changeOnlineWorker
    }
    //MARK: - Inputs -
    func ViewDidLoad(){
    }

    // MARK: - API Call
     func changeOnline(view: UIView) {
        changeOnlineWorker.changeOnline().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.onlineStatus.accept(model.status ?? false)
                ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .LinkMeUIColor.strongGreen)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String ?? "Unknown error"
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(errorMessage)")
            }
        }).disposed(by: disposeBag)
    }
    // MARK: - API Call
     func changeAvailable(view: UIView) {
        changeOnlineWorker.changeAvailable().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.onlineAvailable.accept(model.status ?? false)
                ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .LinkMeUIColor.strongGreen)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String ?? "Unknown error"
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(errorMessage)")
            }
        }).disposed(by: disposeBag)
    }
}
