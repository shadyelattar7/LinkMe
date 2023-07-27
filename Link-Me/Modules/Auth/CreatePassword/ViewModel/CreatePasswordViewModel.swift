//
//  CreatePasswordViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 15/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel
protocol ForgetPasswordInputs{
    
}


//MARK: - ViewController <- ViewModel
protocol ForgetPasswordOutputs{
    var forgetPasswordStatus: PublishSubject<BaseResponse> {get set}
}

class CreatePasswordViewModel: BaseViewModel,ForgetPasswordInputs,ForgetPasswordOutputs{
    
    let forgetpassword: ForgetPasswordWorkerProtocol
    let disposedBag = DisposeBag()
    var email: String?
    var code: String?
    
    init(forgetpassword: ForgetPasswordWorkerProtocol, email: String, code: String) {
        self.forgetpassword = forgetpassword
        self.code = code
        self.email = email
    }
    
    // MARK: - Outputs
     var forgetPasswordStatus: PublishSubject<BaseResponse> = .init()
    
    //MARK: - API Call
    func forgetpassword(password: String,confirmPassword: String,view: UIView){
        forgetpassword.ForgetPassword(model: ForgetPasswordRequestModel(email: self.email ?? "", code: self.code ?? "", password: password, confirmPassword: confirmPassword)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.forgetPasswordStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }

    
}
