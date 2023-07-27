//
//  ChangeEmailViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 25/06/2023.
//

import Foundation
import RxSwift
import RxCocoa


//MARK: - ViewController -> ViewModel

protocol ChangeEmailInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol ChangeEmailOutputs{
    var ConfirmUpdateEmailStatus: PublishSubject<BaseResponse> {get set}
    var VerifyEmailStatus: PublishSubject<BaseResponse> {get set}

}

class ChangeEmailViewModel: BaseViewModel, ChangeEmailInputs, ChangeEmailOutputs{
    
    
    let changeEmail: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    
    
    init(changeEmail: ProfileWorkerProtocol) {
        self.changeEmail = changeEmail
    }
    
    //MARK: - Output -
    
    var ConfirmUpdateEmailStatus: PublishSubject<BaseResponse> = .init()
    var VerifyEmailStatus: PublishSubject<BaseResponse> = .init()
    
    //MARK: - API Call
    
    func changeEmail(email: String, view: UIView){
        let changeEmailReqModel = ChangeEmailRequestModel(email: email)

        changeEmail.changeEmail(model: changeEmailReqModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.VerifyEmailStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
    func confirmUpdateEmail(email: String,code: String, view: UIView){
        let confirmUpdateEmailReqModel = ConfirmUpdateEmailRequestModel(email: email, code: code)

        changeEmail.confirmUpdateEmail(model: confirmUpdateEmailReqModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.ConfirmUpdateEmailStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}
