//
//  OtherSettingsViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 25/06/2023.
//

import Foundation
import RxSwift
import RxCocoa

struct OtherCanSee{
    var title: String
}

//MARK: - ViewController -> ViewModel
protocol OtherSettingsInputs{
    
}


//MARK: - ViewController <- ViewModel
protocol OtherSettingsOutputs{
 //   var verifyCodeStatus: PublishSubject<BaseResponse> {get set}
}

class OtherSettingsViewModel: BaseViewModel,OtherSettingsInputs,OtherSettingsOutputs{
    
    //MARK: - Properties -
    let disposeBag = DisposeBag()
    let blockNetworking: MyBlockWorker
    init(blockNetworking: MyBlockWorker) {
        self.blockNetworking = blockNetworking
    }
    var settingData: BehaviorRelay<[OtherCanSee]> = .init(value: [
        OtherCanSee(title: "Followers".localized),
        OtherCanSee(title: "Likes".localized),
        OtherCanSee(title: "Links".localized)
     //   ,OtherCanSee(title: "Chats".localized)
    ])
    // MARK: - API Call
    func showAndHid(type:String,view: UIView) {
         blockNetworking.showAndHid(model: type).subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                UDHelper.saveUserData(obj: model.data)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String ?? "Unknown error"
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(errorMessage)")
            }
        }).disposed(by: disposeBag)
    }
}
