//
//  RegisterViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 15/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel
protocol RegisterVInputs{
    
}


//MARK: - ViewController <- ViewModel
protocol RegisterOutputs{
    var RegisterStatus: PublishSubject<BaseResponseGen<User>> {get set}

}

class RegisterViewModel: BaseViewModel, RegisterVInputs, RegisterOutputs{
 
    let register: RegisterWorkerProtocol
    let disposedBag = DisposeBag()
    var email: String?
    var code: String?
    
    init(register: RegisterWorkerProtocol, email: String, code: String) {
        self.register = register
        self.code = code
        self.email = email
    }
    
    
    // MARK: - Outputs
     var RegisterStatus: PublishSubject<BaseResponseGen<User>> = .init()
    
    
   //MARK: - Inputs
    var userImg: BehaviorRelay<Data?> = .init(value: nil)
    var logoMimeType: BehaviorRelay<String> = .init(value: "")
    
    
    //MARK: - API Call
    func register(name: String,password: String, birth_date: String, view: UIView){
        let model = RegisterRequestModel(email: email ?? "",
                                         code: code ?? "",
                                         name: name,
                                         password: password,
                                         confirmPassword: password,
                                         birth_date: birth_date)
        
        
        var multiPartArr = [MultiPartData]()
        if let image = self.userImg.value{
            let multiPartRequestmodel = MultiPartData(keyName: "image", fileData: image, mimeType: self.logoMimeType.value,fileName: "image")
            multiPartArr = [multiPartRequestmodel]
        }
        
        register.Register(model: model, fileModel: multiPartArr).subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            print("Model: \(model)")
            switch result{
            case .success(let model):
                UDHelper.token = model.token ?? ""
                UDHelper.saveUserData(obj: model.data)
                UDHelper.isAfterLoginOrRegister = true
                UDHelper.isSkip = false
                UDHelper.isVistor = false
                self.RegisterStatus.onNext(model)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }
}
