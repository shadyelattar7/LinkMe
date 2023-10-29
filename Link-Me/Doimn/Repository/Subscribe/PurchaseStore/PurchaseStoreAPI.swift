//
//  PurchaseStoreAPI.swift
//  Link-Me
//
//  Created by Al-attar on 28/10/2023.
//

import Foundation
import RxSwift

protocol PurchaseStoreAPIProtocol {
    
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func getDiamonds() -> Observable<Result<BaseResponseGen<[DiamondsModel]>, NSError>>
    
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func getStars() -> Observable<Result<BaseResponseGen<[StarsModel]>, NSError>>
   
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func buyDiamonds(model: BuyDiamondsRequestModel) -> Observable<Result<BaseResponse, NSError>>
    
    /// it is the method used to report story.
    /// - Parameters:
    /// - Returns: baseResponse model.
    func buyStars(model: BuyStarsRequestModel) -> Observable<Result<BaseResponse, NSError>>

}

class PurchaseStoreAPI: APIClient<PurchaseStoreTarget>, PurchaseStoreAPIProtocol {
    func getDiamonds() -> RxSwift.Observable<Result<BaseResponseGen<[DiamondsModel]>, NSError>> {
        self.performRequest(target: .getDiamonds)
    }
    
    func getStars() -> RxSwift.Observable<Result<BaseResponseGen<[StarsModel]>, NSError>> {
        self.performRequest(target: .getStars)
    }
    
    func buyDiamonds(model: BuyDiamondsRequestModel) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .buyDiamonds(Parameters: model), requestModel: model)
    }
    
    func buyStars(model: BuyStarsRequestModel) -> RxSwift.Observable<Result<BaseResponse, NSError>> {
        self.performRequest(target: .buyStars(Parameters: model), requestModel: model)
    }
    
}
