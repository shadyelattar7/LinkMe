//
//  VerifyEmailWorkering.swift
//  Link-Me
//
//  Created by Al-attar on 16/05/2023.
//

import Foundation
import RxSwift

protocol VerifyEmailWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func VerifyEmail(model: VerifyEmailRequestModel) -> Observable<Result<BaseResponse, NSError>>
    func VerifyEmailforgetPassword(model: VerifyEmailForgetPasswordRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
}


class VerifyEmailWorker: APIClient<VerifyEmailNetworking>, VerifyEmailWorkerProtocol{
    func VerifyEmail(model: VerifyEmailRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .VerifyEmail(Parameters: model), requestModel: model)
    }
    
    func VerifyEmailforgetPassword(model: VerifyEmailForgetPasswordRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .VerifyEmailForgetPassword(Parameters: model), requestModel: model)
    }
    
}
