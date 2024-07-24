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
    let changeOnlineWorker: ProfileWorkerProtocol
    init(changeOnlineWorker: ProfileWorkerProtocol) {
        self.changeOnlineWorker = changeOnlineWorker
    }
    var settingData: BehaviorRelay<[OtherCanSee]> = .init(value: [
        OtherCanSee(title: "Followers".localized),
        OtherCanSee(title: "Likes".localized),
        OtherCanSee(title: "Links".localized),
        OtherCanSee(title: "Chats".localized)
    ])
    // MARK: - API Call
     func changeLink(view: UIView) {
        changeOnlineWorker.changelink().subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                ToastManager.shared.showToast(message: model.message ?? "", view: view, postion: .top, backgroundColor: .LinkMeUIColor.strongGreen)
            case .failure(let error):
                let errorMessage = error.userInfo["NSLocalizedDescription"] as? String ?? "Unknown error"
                ToastManager.shared.showToast(message: errorMessage, view: view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
                print("ERROR: \(errorMessage)")
            }
        }).disposed(by: disposeBag)
    }
}
