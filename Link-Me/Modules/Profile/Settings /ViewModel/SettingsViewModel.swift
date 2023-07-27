//
//  SettingsViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 20/06/2023.
//

import Foundation
import RxSwift
import RxCocoa


//MARK: - ViewController -> ViewModel
protocol SettingsInputs{
    
}


//MARK: - ViewController <- ViewModel
protocol SettingsOutputs{
 //   var verifyCodeStatus: PublishSubject<BaseResponse> {get set}
}

class SettingsViewModel: BaseViewModel, SettingsInputs, SettingsOutputs{
    
}
