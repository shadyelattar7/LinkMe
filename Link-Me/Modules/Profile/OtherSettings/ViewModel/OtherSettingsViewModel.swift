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
    
    var settingData: BehaviorRelay<[OtherCanSee]> = .init(value: [
        OtherCanSee(title: "Followers".localized),
        OtherCanSee(title: "Likes".localized),
        OtherCanSee(title: "Links".localized),
        OtherCanSee(title: "Chats".localized)
    ])
}
