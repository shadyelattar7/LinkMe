//
//  StoryCell.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import UIKit

class StoryCell: UICollectionViewCell {

    @IBOutlet weak var userImage_iv: UIImageView!
    @IBOutlet weak var userName_lbl: UILabel!
    @IBOutlet weak var add_btn: UIImageView!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    
    private func setupView(){
        let borderColors = [UIColor.rgb(red: 118, green: 78, blue: 232).cgColor,
                            UIColor.rgb(red: 255, green: 35, blue: 130).cgColor]
        let borderWidth: CGFloat = 4.0
        userImage_iv.makeCircleView()
        circleView.makeCircleView()
        circleView.applyGradientBorder(colors: borderColors, width: borderWidth)
    }
    
    func update(_ item: UserStoryData) {
        userName_lbl.text = item.name
        guard let imageStr = item.imagePath else { return }
        userImage_iv.setImage(url: URL(string: imageStr))
    }
}
