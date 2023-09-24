//
//  UIViewController+Animation.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit

// MARK: - Animation when open view

extension UIViewController {
    public func makeViewVisible(view: UIView) {
        view.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
    }
    
    public func showViewFromTop(view: UIView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8) {
                view.transform = .identity
            }
        }
    }
}

