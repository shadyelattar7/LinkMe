//
//  BaseViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel: ViewModel{
    var isLoading: PublishSubject<Bool> = .init()
    var displayError: PublishSubject<String> = .init()
}
