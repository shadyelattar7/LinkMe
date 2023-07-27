//
//  RegisterWorker.swift
//  Link-Me
//
//  Created by Al-attar on 18/05/2023.
//

import Foundation
import Alamofire


enum RegisterNetworking: TargetType{
    case Register (Parameters: RegisterRequestModel, fileModel: [MultiPartData])
}

extension RegisterNetworking{
    var path: String{
        switch self {
        case .Register:
            return "/register"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .Register:
            return .post
        }
    }
    
    var task: Task{
        switch self{
        case .Register(let Parameters, let fileModel):
            return .multiPart(Parameters, fileModel)
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .Register:
            return ["Accept":"application/json"]
        }
        
    }
}
