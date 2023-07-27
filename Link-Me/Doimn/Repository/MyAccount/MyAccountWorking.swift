//
//  MyAccountWorking.swift
//  Link-Me
//
//  Created by Al-attar on 24/06/2023.
//

import Foundation
import RxSwift

protocol MyAccountWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func myAccount() -> Observable<Result<BaseResponseGen<User>, NSError>>
    
}


class MyAccountWorker: APIClient<MyAccountNetworking>, MyAccountWorkerProtocol{
    func myAccount() -> Observable<Result<BaseResponseGen<User>, NSError>> {
        self.performRequest(target: .myAccount)
    }
}
