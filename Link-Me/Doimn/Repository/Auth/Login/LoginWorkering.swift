//
//  LoginWorkering.swift
//  Link-Me
//
//  Created by Al-attar on 19/05/2023.
//

import Foundation
import RxSwift

protocol LoginWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func Login(model: LoginRequestModel) -> Observable<Result<BaseResponseGen<User>, NSError>>
    
}


class LoginWorker: APIClient<LoginNetworking>, LoginWorkerProtocol{
    func Login(model: LoginRequestModel) -> Observable<Result<BaseResponseGen<User>, NSError>> {
        self.performRequest(target: .Login(Parameters: model), requestModel: model)
    }
    
}
