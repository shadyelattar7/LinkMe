//
//  VerifyCodeWorker.swift
//  Link-Me
//
//  Created by Al-attar on 18/05/2023.
//

import Foundation
import Alamofire


enum VerifyCodeNetworking: TargetType{
    case VerifyCode (Parameters: VerifyCodeRequestModel)
}

extension VerifyCodeNetworking{
    var path: String{
        switch self {
        case .VerifyCode:
            return "/verify-code"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .VerifyCode:
            return .post
        }
    }
    
    var task: Task{
        switch self{
        case .VerifyCode(let Parameters):
            return .request(Parameters)
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .VerifyCode:
            return ["Accept":"application/json"]
        }
        
    }
}
