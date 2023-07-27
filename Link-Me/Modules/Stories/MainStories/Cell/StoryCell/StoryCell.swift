//
//  StoryCell.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit

class StoryCell: UICollectionViewCell {

    @IBOutlet weak var userImage_iv: CircleImageView!
    @IBOutlet weak var userName_lbl: UILabel!
    @IBOutlet weak var add_btn: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    
    private func setupView(){
        let borderColors = [UIColor.rgb(red: 118, green: 78, blue: 232).cgColor,
                            UIColor.rgb(red: 255, green: 35, blue: 130).cgColor]
        let borderWidth: CGFloat = 4.0
        addGradientBorder(to: userImage_iv, colors: borderColors, width: borderWidth)
    }
    
    func addGradientBorder(to view: UIView, colors: [CGColor], width: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = colors
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(roundedRect: view.bounds,cornerRadius: userImage_iv.bounds.width / 2).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor // Set the fallback border color
        gradientLayer.mask = shapeLayer
        view.layer.addSublayer(gradientLayer)
    }
}
