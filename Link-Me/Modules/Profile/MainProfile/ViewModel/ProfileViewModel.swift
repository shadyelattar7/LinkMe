//
//  ProfileViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 14/06/2023.
//

import Foundation
import RxCocoa
import RxSwift


//MARK: - ViewController -> ViewModel

protocol ProfileInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol ProfileOutputs{
    var myAccountStatus: PublishSubject<BaseResponseGen<User>> {get set}

}

class ProfileViewModel: BaseViewModel,ProfileInputs,ProfileOutputs{
    
    //MARK: - Properties
    
    let myAccount: MyAccountWorkerProtocol
    let disposedBag = DisposeBag()
    var settingData: BehaviorRelay<[SettingOptions]> = .init(
        value: [
            SettingOptions(
                name: "Settings",
                name_ar: "الإعدادات",
                icon: "Settings",
                isToggle: false,
                isLabel: false,
                isArrow: true,
                isNotificationLabel: false
            ),
            SettingOptions(
                name: "Edit Profile",
                name_ar: "تحرير الملف الشخصي",
                icon: "Edit Profile",
                isToggle: false,
                isLabel: false,
                isArrow: true,
                isNotificationLabel: false
            ),
            SettingOptions(
                name: "Share Profile",
                name_ar: "مشاركة الملف الشخصي",
                icon: "Share Profile",
                isToggle: false,
                isLabel: false,
                isArrow: true,
                isNotificationLabel: false
            ),
            SettingOptions(
                name: "Get All Features",
                name_ar: "الحصول على جميع الميزات",
                icon: "Get All Features",
                isToggle: false,
                isLabel: false,
                isArrow: true,
                isNotificationLabel: false
            ),
        ]
    )

    init(myAccount: MyAccountWorkerProtocol) {
        self.myAccount = myAccount
    }
  
    // MARK: - Outputs -
    
    var myAccountStatus: PublishSubject<BaseResponseGen<User>> = .init()
    
    //MARK: - Inputs -
    func ViewDidLoad(){
        getMyAccountData()
    }
    
    
    
    //MARK: - API Call -
    
   private func getMyAccountData(){
        myAccount.myAccount().subscribe(onNext:{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let model):
                UDHelper.saveUserData(obj: model.data)
                self.myAccountStatus.onNext(model)
            case .failure(let error):
                _ = error.userInfo["NSLocalizedDescription"] as! String
                print("ERROR IN MY ACCOUNT ❌❌❌: \(error)")
            }
        }).disposed(by: disposedBag)
    }
    
}
