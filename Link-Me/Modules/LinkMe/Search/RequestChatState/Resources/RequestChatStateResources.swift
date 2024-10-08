//
//  RequestChatStateResources.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 05/10/2023.
//

import UIKit

/// Model That need to add it for handle card info.
///
struct RequestChatModel {
    let userId: Int?
    let isSpecialSearch: Int?
    let currentUserImageView: UIImage
    let targetUserImageView: UIImage?
    let userName: String
    let userAge: String
    let userCountry: String
   
    
    init(userId: Int, isSpecialSearch: Int, currentUserImageView: UIImage, targetUserImageView: UIImage, userName: String, userAge: String, userCountry: String) {
        self.userId = userId
        self.isSpecialSearch = isSpecialSearch
        self.currentUserImageView = currentUserImageView
        self.targetUserImageView = targetUserImageView
        self.userName = userName
        self.userAge = userAge
        self.userCountry = userCountry
    }
    
    init(userId: Int, isSpecialSearch: Int, currentUserImageView: UIImage, userName: String, userAge: String, userCountry: String) {
        self.userId = userId
        self.isSpecialSearch = isSpecialSearch
        self.currentUserImageView = currentUserImageView
        self.targetUserImageView = nil
        self.userName = userName
        self.userAge = userAge
        self.userCountry = userCountry
    }
}

/// State of request chat.
///
enum RequestChatState {
    case beforeSendRequest(model: RequestChatModel)
    case waitingForResponse(model: RequestChatModel)
    case ignoreYourRequest(model: RequestChatModel)
    case acceptYourRequest(model: RequestChatModel)
    
    var targetUserImageView: UIImage? {
        switch self {
        case .beforeSendRequest(let model): return model.targetUserImageView
        case .waitingForResponse(let model): return model.targetUserImageView
        case .ignoreYourRequest(let model): return model.targetUserImageView
        case .acceptYourRequest(let model): return model.targetUserImageView
        }
    }
    
    var currentUserImageView: UIImage? {
        switch self {
        case .beforeSendRequest: return nil
        case .waitingForResponse: return .waitingForResponse
        case .ignoreYourRequest: return .brokenHeart
        case .acceptYourRequest(let model): return model.currentUserImageView
        }
    }
    
    var userName: String {
        switch self {
        case .beforeSendRequest(let model): return model.userName
        case .waitingForResponse(let model): return model.userName
        case .ignoreYourRequest(let model): return model.userName
        case .acceptYourRequest(let model): return model.userName
        }
    }
    
    var userAge: String {
        switch self {
        case .beforeSendRequest(let model): return model.userAge
        case .waitingForResponse(let model): return model.userAge
        case .ignoreYourRequest(let model): return model.userAge
        case .acceptYourRequest(let model): return model.userAge
        }
    }
    
    var userCountry: String {
        switch self {
        case .beforeSendRequest(let model): return model.userCountry
        case .waitingForResponse(let model): return model.userCountry
        case .ignoreYourRequest(let model): return model.userCountry
        case .acceptYourRequest(let model): return model.userCountry
        }
    }
    
    var descriptionText: String? {
        switch self {
        case .beforeSendRequest:
            return nil
        case .waitingForResponse:
            return "its \(userName) turn now, will accept your request or ignore it"
        case .ignoreYourRequest:
            return "Opps!! \(userName) ignore your request"
        case .acceptYourRequest:
            return "Wow!! \(userName) accept your request start chat now!"
        }
    }
    
    var descriptionTextColor: UIColor? {
        switch self {
        case .beforeSendRequest: return nil
        case .waitingForResponse: return .black
        case .ignoreYourRequest: return .LinkMeUIColor.strongPink
        case .acceptYourRequest: return .LinkMeUIColor.strongGreen
        }
    }
    
    var activeButtonTitle: String {
        switch self {
        case .beforeSendRequest, .ignoreYourRequest: return "Cancel"
        case .waitingForResponse: return "Waiting Approval "
        case .acceptYourRequest: return "Start Chat"
        }
    }
    
    var activeButtonImage: UIImage? {
        switch self {
        case .acceptYourRequest: return .chat
        default: return nil
        }
    }
    
    var activeButtonBackground: UIColor {
        switch self {
        case .acceptYourRequest: return .mainColor
        default: return .lightGray
        }
    }
    
    var activeButtonTextColor: UIColor {
        switch self {
        case .acceptYourRequest: return .white
        default: return .strongGray
        }
    }
}
