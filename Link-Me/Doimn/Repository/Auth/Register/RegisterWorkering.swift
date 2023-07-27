//
//  RegisterWorkering.swift
//  Link-Me
//
//  Created by Al-attar on 18/05/2023.
//

import Foundation
import RxSwift

protocol RegisterWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func Register(model: RegisterRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponseGen<User>, NSError>>
    
}


class RegisterWorker: APIClient<RegisterNetworking>, RegisterWorkerProtocol{
    func Register(model: RegisterRequestModel, fileModel: [MultiPartData]) -> Observable<Result<BaseResponseGen<User>, NSError>> {
        self.performMultipartRequest(target: .Register(Parameters: model, fileModel: fileModel))
    }
    
}
