//
//  SubscribeAPI.swift
//  Link-Me
//
//  Created by Al-attar on 01/10/2023.
//

import Foundation
import RxSwift

protocol SubscribeAPIProtocol {
    
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func supscriptionSubscribe(model: SupscriptionSubscribeRequestModel) -> Observable<Result<BaseResponse, NSError>>
}

class SubscribeAPI: APIClient<SubscribeTarget>, SubscribeAPIProtocol {
    func supscriptionSubscribe(model: SupscriptionSubscribeRequestModel) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .supscriptionSubscribe(Parameters: model), requestModel: model)
    }
   
}
