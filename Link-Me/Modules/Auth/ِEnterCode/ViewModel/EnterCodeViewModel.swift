//
//  EnterCodeViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 14/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum PhoneVerificationEnum{
    case signUp
    case resetPassword
    case changeEmail
}

//MARK: - ViewController -> ViewModel
protocol EnterCodeInputs{
    
}


//MARK: - ViewController <- ViewModel
protocol EnterCodeOutputs{
    var verifyCodeStatus: PublishSubject<BaseResponse> {get set}
}

class EnterCodeViewModel: BaseViewModel, EnterCodeInputs, EnterCodeOutputs{
    
    var source: PhoneVerificationEnum!
    var email: String?
    let verifyCode: VerifyCodeWorkerProtocol
    let disposedBag = DisposeBag()
    
    init(source: PhoneVerificationEnum, verifyCode: VerifyCodeWorkerProtocol,email: String ) {
        self.verifyCode = verifyCode
        self.source = source
        self.email = email
    }
    
    // MARK: - Outputs
    
     var verifyCodeStatus: PublishSubject<BaseResponse> = .init()
    
    
    
    //MARK: - API Call
    
    func VerifyCode(Code: String,view: UIView){
        verifyCode.VerifyCode(model: VerifyCodeRequestModel(email: email ?? "", code: Code)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.verifyCodeStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}
