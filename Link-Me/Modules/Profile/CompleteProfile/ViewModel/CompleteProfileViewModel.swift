//
//  CompleteProfileViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 16/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - ViewController -> ViewModel

protocol CompleteProfileInputs{
    var Countries: BehaviorRelay<[Countries]> {get set}
}


//MARK: - ViewController <- ViewModel

protocol CompleteProfileOutputs{
    var completeProfileStatus: PublishSubject<BaseResponseGen<User>> {get set}

}

class CompleteProfileViewModel: BaseViewModel, CompleteProfileInputs, CompleteProfileOutputs{
    
    
    let completeProfile: ProfileWorkerProtocol
    let fromAuth: Bool
    let disposedBag = DisposeBag()
    var Countries: BehaviorRelay<[Countries]> = .init(value: [])
    let dismissSubject = PublishSubject<Bool>()
    init(completeProfile: ProfileWorkerProtocol,fromAuth: Bool) {
        self.completeProfile = completeProfile
        self.fromAuth = fromAuth
    }
        
    
    //MARK: - Output -
    
    var completeProfileStatus: PublishSubject<BaseResponseGen<User>> = .init()

    
    var numberOfCountries: Int {
        return Countries.value.count
    }
    
    //MARK: - Input -
    
    func ViewDidLoad(view: UIView){
        getCountries(view: view)
    }
 
    //MARK: - API Call
    
    func getCountries(view: UIView){
        completeProfile.getCountries().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                self.Countries.accept(model.data ?? [])
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
            }
        }).disposed(by: disposedBag)
    }

    
    func completeProfile(country_id: Int, bio: String, gander: String, view: UIView, completion: @escaping (Bool) -> Void) {
        var errorMessage: String = ""
        guard country_id != 0, !bio.isEmpty, !gander.isEmpty else {
            var errorMessage = ""
             if country_id == 0 {
                 errorMessage = "You should choose a Country".localized
             }
           else  if gander.isEmpty {
               errorMessage = "You should choose a Gender".localized
             }
            else  if bio.isEmpty {
                errorMessage = "Bio is empty".localized
              }
            ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
            completion(false) // Call completion with failure
            return
        }
        
        completeProfile.completeProfile(model: CompleteProfileRequestModel(country_id: country_id, bio: bio, gander: gander)).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                UDHelper.saveUserData(obj: model.data)
                self.completeProfileStatus.onNext(model)
                self.dismissSubject.onNext(true)
                if fromAuth {
                    completion(true) // Call completion with success
                }
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as! String
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(error)")
                completion(false) // Call completion with failure
            }
        }).disposed(by: disposedBag)
    }
    
}
