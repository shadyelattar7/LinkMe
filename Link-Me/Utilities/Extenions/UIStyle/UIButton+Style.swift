//
//  UIButton+Style.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit


// MARK: - Button style
//
extension UIButton {
    enum ButtonStyle {
        case primary
        case border
    }
}

// MARK: - Apply button style
//
extension UIButton {
    func applyButtonStyle(_ style: ButtonStyle) {
        backgroundColor = style.backgroundColor
        titleLabel?.font = style.buttonFont
        tintColor = style.textColor
        layer.cornerRadius = style.cornerRadius
        layer.borderColor = style.borderColor?.cgColor
        layer.borderWidth = style.borderWidth ?? 0
        layer.masksToBounds = true
        let heightConstraint = heightAnchor.constraint(equalToConstant: style.defaultHeight)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }
}

// MARK: Button Style Configurations
//
private extension UIButton.ButtonStyle {
    var backgroundColor: UIColor? {
        switch self {
        case .primary: return .mainColor
        case .border: return .white
        }
    }

    var textColor: UIColor? {
        switch self {
        case .primary: return .white
        case .border: return .mainColor
        }
    }

    var buttonFont: UIFont? {
        switch self {
        case .primary: return UIFont(name: ENFont.Bold.rawValue, size: 17)
        case .border: return UIFont(name: ENFont.Bold.rawValue, size: 17)
        }
    }

    var defaultHeight: CGFloat {
        switch self {
        case .primary, .border: return 40.0
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .primary, .border: return 12.0
        }
    }
    
    var borderColor: UIColor? {
        switch self {
        case .primary: return nil
        case .border: return .mainColor
        }
    }
    
    var borderWidth: CGFloat? {
        switch self {
        case .primary: return nil
        case .border: return 1.0
        }
    }
}
