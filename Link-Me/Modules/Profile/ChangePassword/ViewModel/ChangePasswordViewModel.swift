//
//  ChangePasswordViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 25/06/2023.
//

import Foundation
import RxSwift
import RxCocoa


//MARK: - ViewController -> ViewModel

protocol ChangePasswordInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol ChangePasswordOutputs{
    var ChangePasswordStatus: PublishSubject<BaseResponse> {get set}

}

class ChangePasswordViewModel: BaseViewModel, ChangePasswordInputs, ChangePasswordOutputs{
 
    let changePassword: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    
    
    init(changePassword: ProfileWorkerProtocol) {
        self.changePassword = changePassword
 
    }
    
    //MARK: - Output -
    
    var ChangePasswordStatus: PublishSubject<BaseResponse> = .init()
    
    
    //MARK: - API Call
    
    func changePassword(oldPassword: String,password: String,confirmPassword: String, view: UIView){
        let changePasswordReqModel = ChangePasswordRequestModel(oldPassword: oldPassword, password: password, confirmPassword: confirmPassword)
        
        changePassword.changePassword(model: changePasswordReqModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.ChangePasswordStatus.onNext(model)
                ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top , backgroundColor: .LinkMeUIColor.strongGreen)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}
