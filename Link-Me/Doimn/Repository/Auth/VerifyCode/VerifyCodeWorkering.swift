//
//  VerifyCodeWorkering.swift
//  Link-Me
//
//  Created by Al-attar on 18/05/2023.
//

import Foundation
import RxSwift

protocol VerifyCodeWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func VerifyCode(model: VerifyCodeRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
}


class VerifyCodeWorker: APIClient<VerifyCodeNetworking>, VerifyCodeWorkerProtocol{
    func VerifyCode(model: VerifyCodeRequestModel) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .VerifyCode(Parameters: model), requestModel: model)
    }
    
}
