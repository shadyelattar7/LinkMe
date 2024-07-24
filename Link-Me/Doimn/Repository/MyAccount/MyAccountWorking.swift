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

protocol MyBlockWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func getBlockUsers() -> Observable<Result<BaseResponseGen<blockUserModel>, NSError>>
   
    func setUnBlockUser(model: Int) -> Observable<Result<BaseResponse, NSError>>
}


class MyBlockWorker: APIClient<BlockNetworking>, MyBlockWorkerProtocol{
    func getBlockUsers() -> Observable<Result<BaseResponseGen<blockUserModel>, NSError>> {
        self.performRequest(target: .blockUser)
    }
    func setUnBlockUser(model: Int) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .unBlockUser(userId: model),requestModel: model)
    }
}
struct blockUserModel :Codable {
    var current_page : Int?
    var data : [User]
}
