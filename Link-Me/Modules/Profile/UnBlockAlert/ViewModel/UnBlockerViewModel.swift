//
//  UnBlockerViewModel.swift
//  Link-Me
//
//  Created by Ahmed_POMAC on 24/07/2024.
//

import Foundation
import RxSwift
import RxCocoa


//MARK: - ViewController -> ViewModel

protocol UnBlockerInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol UnBlockerOutputs{
//    var DeleteAccountStatus: PublishSubject<BaseResponse> {get set}
}
class UnBlockerViewModel: BaseViewModel, UnBlockerInputs, UnBlockerOutputs{
    //MARK: - Properties
    private let disposedBag = DisposeBag()
    
    let myBlockUser: MyBlockWorkerProtocol
    var user: UnblockUserModel?
    let dismissSubject = PublishSubject<Bool>()
    var userId:Int?
    init(user: UnblockUserModel , BlockUser: MyBlockWorkerProtocol = MyBlockWorker()) {
        self.myBlockUser = BlockUser
        self.user = user
        self.userId = user.id
        print(user.name)
        super.init()
        
    }
    //     MARK: Call ApI...
        func setUnBlockUser(view: UIView) {
            guard let userId = userId else{return}
                myBlockUser.setUnBlockUser(model: userId).subscribe(onNext: { [weak self] result in
                   guard let self = self else { return }
                   switch result {
                   case .success(let model):
                       print(model)
                       self.dismissSubject.onNext(true)
                       ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .LinkMeUIColor.strongGreen)
                   case .failure(let error):
                       let errorMessage = error.userInfo["NSLocalizedDescription"] as? String ?? "Unknown error"
                       ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
                       print("ERROR: \(errorMessage)")
                   }
               }).disposed(by: disposedBag)
           }
    
}
