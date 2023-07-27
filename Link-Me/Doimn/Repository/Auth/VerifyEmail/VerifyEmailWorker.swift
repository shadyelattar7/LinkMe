//
//  AuthWorker.swift
//  Link-Me
//
//  Created by Al-attar on 16/05/2023.
//

import Foundation
import Alamofire


enum VerifyEmailNetworking: TargetType{
    case VerifyEmail (Parameters: VerifyEmailRequestModel)
    case VerifyEmailForgetPassword (Parameters: VerifyEmailForgetPasswordRequestModel)
}

extension VerifyEmailNetworking{
    var path: String{
        switch self {
        case .VerifyEmail:
            return "/send-verify-code"
        case .VerifyEmailForgetPassword:
            return "/forget-password"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .VerifyEmail:
            return .post
        case .VerifyEmailForgetPassword:
            return .post
        }
    }
    
    var task: Task{
        switch self{
        case .VerifyEmail(let Parameters):
            return .request(Parameters)
        case .VerifyEmailForgetPassword(let Parameters):
            return .request(Parameters)
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .VerifyEmail, .VerifyEmailForgetPassword:
            return ["Accept":"application/json"]
        }
        
    }
}
