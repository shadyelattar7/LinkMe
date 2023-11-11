//
//  LoginWorker.swift
//  Link-Me
//
//  Created by Al-attar on 19/05/2023.
//

import Foundation
import Alamofire


enum LoginNetworking: TargetType{
    case Login (Parameters: LoginRequestModel)
    case vistor
}

extension LoginNetworking{
    var path: String{
        switch self {
        case .Login:
            return "/login"
        case .vistor:
            return "/visitor/register"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .Login:
            return .post
        case .vistor:
            return .post
        }
    }
    
    var task: Task{
        switch self{
        case .Login(let Parameters):
            return .request(Parameters)
        case .vistor:
            return .requestPlain
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .Login:
            return ["Accept":"application/json"]
        case .vistor:
            return [:]
        }
        
    }
}
