//
//  VerifyEmailViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 14/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel

protocol VerifyEmailVInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol VerifyEmailOutputs{
    var verifyEmailStatus: PublishSubject<BaseResponse> {get set}

}

class VerifyEmailViewModel: BaseViewModel, VerifyEmailOutputs, VerifyEmailVInputs{

    var source: PhoneVerificationEnum!
    let verifyEmail: VerifyEmailWorkerProtocol
    let disposedBag = DisposeBag()
    
    init(verifyEmail: VerifyEmailWorkerProtocol,source: PhoneVerificationEnum!) {
        self.verifyEmail = verifyEmail
        self.source = source
    }
    
    // MARK: - Outputs
    
     var verifyEmailStatus: PublishSubject<BaseResponse> = .init()
    
   
    
    //MARK: - API Call
    
    func VerifyEmail(email: String, view: UIView){
        verifyEmail.VerifyEmail(model: VerifyEmailRequestModel(email: email)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.verifyEmailStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
    func VerifyEmailForgetPassword(email: String, view: UIView){
        verifyEmail.VerifyEmailforgetPassword(model: VerifyEmailForgetPasswordRequestModel(email: email)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.verifyEmailStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
}
