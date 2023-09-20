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
        userImage_iv.addGradientBorder(colors: borderColors, width: borderWidth)
    }
}
