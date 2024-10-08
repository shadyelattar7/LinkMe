//
//  BottomListSheet+Resources.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import UIKit

/// - Item list type with attributes [title, image, background color for image].
///
///
enum ItemList {
    case report
    case unfriend
    case blockUser(userID: Int)
    case deleteStory
    case editStory
    case deleteChat
    case addFriend
    case reportUser
    case deleteForEveryone(messageID: Int)
    case deleteForMe(messageID: Int)
    case blockUserInChat(userID: Int)
    
    var title: String {
        switch self {
        case .report: return "Report"
        case .unfriend: return "Unfriend"
        case .blockUser: return "Block This User"
        case .deleteStory: return "Delete Story"
        case .editStory: return "Edit Story"
        case .deleteChat: return "Delete This Chat"
        case .addFriend: return "Add friend"
        case .reportUser: return "Report this User"
        case .deleteForEveryone: return "Delete For Everyone"
        case .deleteForMe: return "Delete For Me"
        case .blockUserInChat: return "Block This User"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .report: return UIImage(named: "report")
        case .unfriend: return UIImage(named: "addCircle")
        case .blockUser, .blockUserInChat: return UIImage(named: "shieldCross")
        case .deleteStory, .deleteChat, .deleteForMe, .deleteForEveryone: return UIImage(named: "trash")
        case .editStory: return UIImage(named: "edit")
        case .addFriend: return UIImage(named: "Group 63358")
        case .reportUser: return UIImage(named: "report")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .report, .unfriend, .blockUser, .blockUserInChat, .editStory, .addFriend, .reportUser: return .lightGray
        case .deleteStory, .deleteChat, .deleteForMe, .deleteForEveryone: return UIColor(red: 1, green: 0.88, blue: 1, alpha: 1)
        }
    }
}
