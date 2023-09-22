//
//  UIView+extension.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/09/2023.
//

import UIKit


/// Add gradient to view.
/// 
extension UIView {
    func addGradientBorder(colors: [CGColor], width: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(roundedRect: self.bounds,cornerRadius: self.bounds.width / 2).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor // Set the fallback border color
        gradientLayer.mask = shapeLayer
        self.layer.addSublayer(gradientLayer)
    }
}
