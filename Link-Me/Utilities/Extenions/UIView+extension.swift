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
    func applyGradientBorder(colors: [CGColor], width: CGFloat) {
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

/// Add gradient.
///
extension UIView {
    func applyGradient(colors: [CGColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.cornerRadius = self.layer.cornerRadius
        gradient.frame = self.layer.frame
        self.clipsToBounds = true
        self.layer.insertSublayer(gradient, at: 0)
    }
}

// MARK: add corner radius

extension UIView {
    func makeCircleView() {
        self.layer.cornerRadius = self.layer.bounds.width / 2
        self.clipsToBounds = true
    }
}

// MARK: Init view from nib.

extension UIView {
    /// Loads a view from a nib file and adds it as a subview to the current view instance..
    func loadViewFromNib(bundle: Bundle? = nil) {
        let nibName = String(describing: Self.self)
        let bundle = Bundle(for: Self.self)
        let nib = UINib(nibName: nibName, bundle: bundle)

        guard let contentView = nib.instantiate(withOwner: self).first as? UIView else {
            assertionFailure("unable to find the content view")
            return
        }

        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}
