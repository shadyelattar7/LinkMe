//
//  ForgetPasswordWorking.swift
//  Link-Me
//
//  Created by Al-attar on 25/05/2023.
//

import Foundation
import RxSwift

protocol ForgetPasswordWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func ForgetPassword(model: ForgetPasswordRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
}


class ForgetPasswordWorker: APIClient<ForgetPasswordNetworking>, ForgetPasswordWorkerProtocol{
    func ForgetPassword(model: ForgetPasswordRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .ForgetPassword(Parameters: model), requestModel: model)
    }
}
