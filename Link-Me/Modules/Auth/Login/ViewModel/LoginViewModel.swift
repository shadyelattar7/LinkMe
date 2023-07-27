//
//  LoginViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 13/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel

protocol LoginVInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol LoginOutputs{
    var loginStatus: PublishSubject<BaseResponseGen<User>> {get set}

}

class LoginViewModel: BaseViewModel, LoginVInputs,LoginOutputs {
    
    
    let login: LoginWorkerProtocol
    let disposedBag = DisposeBag()
    
    init(login: LoginWorkerProtocol) {
        self.login = login
 
    }
    
    
    // MARK: - Outputs
    
   //  var loginStatus: PublishSubject<BaseResponseGen<User>> = .init()
     var loginStatus: PublishSubject<BaseResponseGen<User>> = .init()

    
    //MARK: - API Call
    
    func login(email: String, password: String,view: UIView){
         login.Login(model: LoginRequestModel(email: email, password: password)).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                UDHelper.token = model.token ?? ""
                UDHelper.saveUserData(obj: model.data)
                UDHelper.isAfterLoginOrRegister = true
                UDHelper.isSkip = false
                self.loginStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }

}
