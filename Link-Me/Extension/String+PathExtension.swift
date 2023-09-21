//
//  String+extension.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 21/09/2023.
//

import Foundation

/// Types of path extension.
///
enum PathExtensionType {
    case video
    case image
    case unowned
}

/// Get path extension from string.
///
extension String {
    func getPathExtension() -> String {
        return (self as NSString).pathExtension
    }
}

/// Func used to detect type of path extension.
/// 
extension String {
    func getPathExtensionType() -> PathExtensionType {
        switch self.getPathExtension() {
        case "mp4":
            return .video
        case "jpeg":
            return .image
        default:
            return .unowned
        }
    }
}

