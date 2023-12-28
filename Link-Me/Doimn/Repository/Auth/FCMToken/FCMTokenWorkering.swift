//
//  FCMTokenWorkering.swift
//  Link-Me
//
//  Created by Al-attar on 02/12/2023.
//

import Foundation
import RxSwift

protocol FCMTokenWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func sendFCMToken() -> Observable<Result<BaseResponseGen<User>, NSError>>
}


class FCMTokenWorker: APIClient<FCMTokenNetworking>, FCMTokenWorkerProtocol{
    func sendFCMToken() -> RxSwift.Observable<Result<BaseResponseGen<User>, NSError>> {
        self.performRequest(target: .sendFCMToken)
    }
}
