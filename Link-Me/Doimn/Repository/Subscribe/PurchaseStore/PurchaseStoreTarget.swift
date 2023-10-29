//
//  PurchaseStoreTarget.swift
//  Link-Me
//
//  Created by Al-attar on 28/10/2023.
//

import Foundation
import Alamofire

enum PurchaseStoreTarget {
    case getDiamonds
    case getStars
    case buyDiamonds(Parameters: BuyDiamondsRequestModel)
    case buyStars(Parameters: BuyStarsRequestModel)
}

extension PurchaseStoreTarget: TargetType {
    var path: String {
        switch self {
        case .getDiamonds:
            return "/supscription/products"
        case .getStars:
            return "/supscription/stars"
        case .buyDiamonds:
            return "/supscription/buy-diamonds"
        case .buyStars:
            return "/supscription/buy-stars"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getDiamonds:
            return .get
        case .getStars:
            return .get
        case .buyDiamonds:
            return .post
        case .buyStars:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getDiamonds:
            return .requestPlain
        case .getStars:
            return .requestPlain
        case .buyDiamonds(let Parameters):
            return .request(Parameters)
        case .buyStars(let Parameters):
            return .request(Parameters)
        }
    }
    
    var headers: [String : String] {
        return ["Authorization": "Bearer \(UDHelper.token)"]
    }
}
