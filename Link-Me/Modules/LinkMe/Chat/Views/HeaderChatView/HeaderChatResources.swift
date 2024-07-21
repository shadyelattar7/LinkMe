//
//  HeaderChatResources.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import UIKit

enum HeaderChatButtonType {
    case add
    case send
    case accept
    case ignore
    case endChat
    
    var buttonTitle: String {
        switch self {
        case .add: return "add"
        case .send: return "send"
        case .accept: return "Accept"
        case .ignore: return "ignore"
        case .endChat: return "end chat"
        }
    }
    
    var buttonImage: UIImage? {
        switch self {
        case .add: return .iconPlus
        case .send: return .iconCheck
        case .endChat: return .exit
        default: return nil
        }
    }
    
    var buttonBackgroundColor: UIColor {
        switch self {
        case .add, .send: return UIColor(hexString: "#E8E1FF")
        case .accept: return UIColor(hexString: "#24CB98")
        case .ignore: return .white
        case .endChat: return UIColor(hexString: "#FFE1FF")
        }
    }
    
    var buttonTextColor: UIColor {
        switch self {
        case .add, .send: return UIColor(hexString: "#764EE8")
        case .accept: return .white
        case .ignore: return UIColor(hexString: "#24CB98")
        case .endChat: return UIColor(hexString: "#FF2382")
        }
    }
    
    var buttonBorderColor: UIColor? {
        switch self {
        case .ignore: return UIColor(hexString: "#24CB98")
        default: return nil
        }
    }
    
    var buttonBorderWidth: CGFloat? {
        switch self {
        case .ignore: return 1.0
        default: return nil
        }
    }
    
    var action: (() -> Void)? {
        switch self {
        case .add:
            return {
                print("Add button tapped")
            }
        case .send:
            return {
                print("Send button tapped")
            }
        case .accept:
            return {
                print("Accept button tapped")
            }
        case .ignore:
            return {
                print("Ignore button tapped")
            }
        case .endChat:
            return {
                print("End chat button tapped")
            }
        }
    }
}


enum HeaderViewType {
    case beforeSendAddRequest
    case sendAddRequest
    case acceptOrIgnoreAddRequest
    case ignoreAddRequest
    
    
    var firstButtonType: HeaderChatButtonType? {
        switch self {
        case .beforeSendAddRequest: return .add
        case .sendAddRequest: return .send
        case .acceptOrIgnoreAddRequest: return .accept
        case .ignoreAddRequest: return nil
        }
    }
    
    var secondButtonType: HeaderChatButtonType? {
        switch self {
        case .beforeSendAddRequest, .sendAddRequest, .ignoreAddRequest: return .endChat
        case .acceptOrIgnoreAddRequest: return .ignore
        }
    }
    
    var isHiddenFirstButton: Bool {
        switch self {
        case .ignoreAddRequest: return true
        default: return false
        }
    }
    
    var isHiddenIgnoreMessage: Bool {
        switch self {
        case .ignoreAddRequest: return false
        default: return true
        }
    }
}
