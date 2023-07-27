//
//  ForgetPasswordWorker.swift
//  Link-Me
//
//  Created by Al-attar on 25/05/2023.
//

import Foundation
import Alamofire


enum ForgetPasswordNetworking: TargetType{
    case ForgetPassword (Parameters: ForgetPasswordRequestModel)
}

extension ForgetPasswordNetworking{
    var path: String{
        switch self {
        case .ForgetPassword:
            return "/reset-password"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .ForgetPassword:
            return .post
        }
    }
    
    var task: Task{
        switch self{
        case .ForgetPassword(let Parameters):
            return .request(Parameters)
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .ForgetPassword:
            return ["Accept":"application/json"]
        }
        
    }
}
