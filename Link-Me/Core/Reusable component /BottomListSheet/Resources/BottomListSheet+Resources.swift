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
    
    var title: String {
        switch self {
        case .report: return "Report"
        case .unfriend: return "Unfriend"
        case .blockUser: return "Block This User"
        case .deleteStory: return "Delete Story"
        case .editStory: return "Edit Story"
        case .deleteChat: return "Delete This Chat"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .report: return UIImage(named: "report")
        case .unfriend: return UIImage(named: "addCircle")
        case .blockUser: return UIImage(named: "shieldCross")
        case .deleteStory, .deleteChat: return UIImage(named: "trash")
        case .editStory: return UIImage(named: "edit")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .report, .unfriend, .blockUser, .editStory: return .lightGray
        case .deleteStory, .deleteChat: return UIColor(red: 1, green: 0.88, blue: 1, alpha: 1)
        }
    }
}
