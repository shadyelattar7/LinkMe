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
}

class LinkMeAPI: APIClient<LinkMeTarget>, LinkMeAPIProtocol {
    func fetchTopUsers() -> Observable<Result<BaseResponseGen<TopUserData>, NSError>> {
        self.performRequest(target: .topUsers)
    }
}
