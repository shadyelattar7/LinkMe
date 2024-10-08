//
//  MyBlockWorker.swift
//  Link-Me
//
//  Created by Ahmed Eltrass on 29/07/2024.
//
import Alamofire
enum BlockNetworking: TargetType{
    case blockUser
    case unBlockUser(userId:Int)
    case showAndHid(type: String)
}

extension BlockNetworking{
    var path: String{
        switch self {
        case .blockUser:
            return "/users/blocks"
        case .unBlockUser(let user_id):
            return "/users/blocks/delete?user_id=" + "\(user_id)"
        case .showAndHid(let type):
            return "/update-setting?type=\(type)"
        }
    }
        var method: HTTPMethod{
            switch self{
            case .blockUser:
                return .get
            case .unBlockUser:
                return .post
            case .showAndHid:
                return .post
            }
        }
        
        var task: Task{
            switch self{
            case .blockUser:
                return .requestPlain
                
            case .unBlockUser(let userId):
                return .request(userId)
            case .showAndHid(type: let type):
                return .request(type)
            }
        }
        
        var headers: [String : String]{
            switch self {
            case .blockUser,.unBlockUser,.showAndHid:
                return ["Authorization": "Bearer \(UDHelper.token)"]
            }
        }
        
    }
