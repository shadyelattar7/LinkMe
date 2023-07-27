//
//  CompanySupportViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 01/07/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum CompanySupportEnum{
    case AboutUs
    case TermsOfServices
    case PrivacyPolicy
}

//MARK: - ViewController -> ViewModel

protocol CompanySupportInputs{
    
}


//MARK: - ViewController <- ViewModel

protocol CompanySupportOutputs{
 

}

class CompanySupportViewModel: BaseViewModel, CompanySupportInputs, CompanySupportOutputs{
    
    var source: CompanySupportEnum!
    let disposedBag = DisposeBag()
    
    init(source: CompanySupportEnum!) {
        self.source = source
    }
}
