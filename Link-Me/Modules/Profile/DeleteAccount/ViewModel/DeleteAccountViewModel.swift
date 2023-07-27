//
//  DeleteAccountViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 08/07/2023.
//

import Foundation
import RxSwift
import RxCocoa


//MARK: - ViewController -> ViewModel

protocol DeleteAccountInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol DeleteAccountOutputs{
    var DeleteAccountStatus: PublishSubject<BaseResponse> {get set}
}

class DeleteAccountViewModel: BaseViewModel, DeleteAccountInputs, DeleteAccountOutputs{
    
    let DeleteAccount: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    var reason: String
    
    init(DeleteAccount: ProfileWorkerProtocol, reason: String) {
        self.DeleteAccount = DeleteAccount
        self.reason = reason
    }
    
    //MARK: - Output -
    var DeleteAccountStatus: PublishSubject<BaseResponse> = .init()
    
    //MARK: - API Call -
    
    func deleteAccount(password: String, view: UIView){
        let DeleteAccountReqModel = DeleteAccountRequestModel(reason: self.reason, password: password)
        DeleteAccount.deleteAccount(model: DeleteAccountReqModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.DeleteAccountStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
}
