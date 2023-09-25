//
//  UIView+Style.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 25/09/2023.
//

import UIKit

/// Some style for views.
///
extension UIView {
    func applyDefaultStyle(cornerRadius: CGFloat,
                            backgroundColor: UIColor,
                            textColor: UIColor) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.tintColor = textColor
    }

    func applyBorderStyle(borderColor: UIColor,
                          borderWidth: CGFloat,
                          cornerRadius: CGFloat,
                          textColor: UIColor?) {
        self.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.tintColor = textColor
    }
    
    func applyBorderStyle(borderColor: UIColor,
                          borderWidth: CGFloat,
                          cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}
