//
//  SendEmailViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 29/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel

protocol SendEmailInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol SendEmailOutputs{
    var sendEmailStatus: PublishSubject<BaseResponse> {get set}

}

class SendEmailViewModel: BaseViewModel, SendEmailInputs, SendEmailOutputs{
    
    let sendEmail: ProfileWorkerProtocol
    let disposedBag = DisposeBag()
    
    init(sendEmail: ProfileWorkerProtocol) {
        self.sendEmail = sendEmail
    }
    
    //MARK: - Output -
    
    var sendEmailStatus: PublishSubject<BaseResponse> = .init()
    
    //MARK: - API Call -

    func sendEmail(email: String,title: String,description: String, view: UIView){
        let sendEmailReqModel = SendEmailRequestModel(email: email, title: title, description: description, type: "suggestion")

        sendEmail.sendEmail(model: sendEmailReqModel).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.sendEmailStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}
