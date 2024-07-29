//
//  MyAccountWorker.swift
//  Link-Me
//
//  Created by Al-attar on 24/06/2023.
//

import Foundation
import Alamofire


enum MyAccountNetworking: TargetType{
    case myAccount
    
}

extension MyAccountNetworking{
    var path: String{
        switch self {
        case .myAccount:
            return "/myaccount"
       
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .myAccount:
            return .get
       
        }
    }
    
    var task: Task{
        switch self{
        case .myAccount:
            return .requestPlain
        
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .myAccount:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
        
    }
}
