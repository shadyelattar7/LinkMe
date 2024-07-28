//
//  BlockUserViewModel.swift
//  Link-Me
//
//  Created by Ahmed Eltrass on 23/07/2024.
//

import Foundation
import RxCocoa
import RxSwift



//MARK: - ViewController -> ViewModel

protocol BlockUserInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol BlockUserOutputs{
   

}

class BlockUserViewModel: BaseViewModel,BlockUserInputs,BlockUserOutputs{
    //MARK: - Properties
    private let disposedBag = DisposeBag()
    
    let myBlockUser: MyBlockWorkerProtocol
    init(myBlockUser: MyBlockWorkerProtocol) {
        self.myBlockUser = myBlockUser
    }
    private var errorMessage = PublishSubject<String>()
    var errorMessageObservable: Observable<String> {
        return errorMessage.asObservable()
    }
    // MARK: - Outputs -
    
    private var blockUsers = BehaviorRelay<[User]>(value: [])
    var blockUsersObservable: Observable<[User]> {
      return blockUsers.asObservable()
    }
    func getUserModel(_ row: Int) -> User {
        return blockUsers.value[row]
    }
    //MARK: - Inputs -
    func ViewDidLoad(){
        getBlockUser()
    }
//     MARK: Call ApI...
    func setUnBlockUser(userId:Int,view: UIView) {
            myBlockUser.setUnBlockUser(model: userId).subscribe(onNext: { [weak self] result in
               guard let self = self else { return }
               switch result {
               case .success(let model):
                   print(model)
                   getBlockUser()
                   ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .LinkMeUIColor.strongGreen)
               case .failure(let error):
                   let errorMessage = error.userInfo["NSLocalizedDescription"] as? String ?? "Unknown error"
                   ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
                   print("ERROR: \(errorMessage)")
               }
           }).disposed(by: disposedBag)
       }
     func getBlockUser(){
        myBlockUser.getBlockUsers().subscribe(onNext:{ [weak self] result in
             guard let self = self else {return}
             switch result{
             case .success(let model):
                 guard let data = model.data?.data else { return }
                 self.blockUsers.accept(data)
                 print( model.data)
             case .failure(let error):
                 _ = error.userInfo["NSLocalizedDescription"] as! String
                 print("ERROR IN MY ACCOUNT ❌❌❌: \(error)")
             }
         }).disposed(by: disposedBag)
     }
}
