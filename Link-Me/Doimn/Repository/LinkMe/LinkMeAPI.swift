//
//  LinkMeAPI.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 23/09/2023.
//

import Foundation
import RxSwift

protocol LinkMeAPIProtocol {
    
    /// it is the method used to fetch top users
    /// - Parameters:
    /// - Returns: TopUserData.
    func fetchTopUsers() -> Observable<Result<BaseResponseGen<TopUserData>, NSError>>
    
    /// it is the method used to searching for users
    /// - Parameters:
    /// - Returns: users.
    func searchingForUsers(model: SearchRequestModel?) -> Observable<Result<BaseResponseGen<[User]>, NSError>>
    
    /// it is the method used to request chat
    /// - Parameters:
    /// - Returns: users.
    func requestChat(model: RequestChatRequestModel) -> Observable<Result<BaseResponseGen<RequestChatData>, NSError>>
}

class LinkMeAPI: APIClient<LinkMeTarget>, LinkMeAPIProtocol {
    func fetchTopUsers() -> Observable<Result<BaseResponseGen<TopUserData>, NSError>> {
        self.performRequest(target: .topUsers)
    }
    
    func searchingForUsers(model: SearchRequestModel?) -> Observable<Result<BaseResponseGen<[User]>, NSError>> {
        self.performRequest(target: .searchingForUsers(Parameters: model), requestModel: model)
    }
    
    func requestChat(model: RequestChatRequestModel) -> Observable<Result<BaseResponseGen<RequestChatData>, NSError>> {
        self.performRequest(target: .requestChat(Parameters: model), requestModel: model)
    }
}
