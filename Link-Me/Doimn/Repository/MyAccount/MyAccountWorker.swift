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
enum BlockNetworking: TargetType{
    case blockUser
    case unBlockUser(userId:Int)
}

extension BlockNetworking{
    var path: String{
        switch self {
        case .blockUser:
            return "/users/blocks"
        case .unBlockUser(let user_id):
            return "/users/blocks/delete?user_id=" + "\(user_id)"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case .blockUser:
            return .get
        case .unBlockUser:
            return .post
        }
    }
    
    var task: Task{
        switch self{
        case .blockUser:
            return .requestPlain
       
        case .unBlockUser(let userId):
            return .request(userId)
        }
    }
    
    var headers: [String : String]{
        switch self {
        case .blockUser,.unBlockUser:
            return ["Authorization": "Bearer \(UDHelper.token)"]
        }
        
    }
}
