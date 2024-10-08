//
//  MyBlockWorking.swift
//  Link-Me
//
//  Created by Ahmed Eltrass on 29/07/2024.
//

import Foundation
import RxSwift

protocol MyBlockWorkerProtocol{
    
    /// it is the method used to Update Personal Info
    /// - Parameters:
    ///   - params: the user image and store page url
    /// - Returns: merchant model
    func getBlockUsers() -> Observable<Result<BaseResponseGen<blockUserModel>, NSError>>
   
    func setUnBlockUser(model: Int) -> Observable<Result<BaseResponse, NSError>>
    func showAndHid(model: String) -> Observable<Result<BaseResponseGen<User>, NSError>>
}


class MyBlockWorker: APIClient<BlockNetworking>, MyBlockWorkerProtocol{
    func getBlockUsers() -> Observable<Result<BaseResponseGen<blockUserModel>, NSError>> {
        self.performRequest(target: .blockUser)
    }
    func setUnBlockUser(model: Int) -> Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .unBlockUser(userId: model))
    }
    func showAndHid(model: String) -> Observable<Result<BaseResponseGen<User>, NSError>> {
        self.performRequest(target: .showAndHid(type: model))
    }
    
}
struct blockUserModel :Codable {
    var current_page : Int?
    var data : [User]
}
