//
//  SubscriptionCell.swift
//  Link-Me
//
//  Created by Al-attar on 30/09/2023.
//

import UIKit

class SubscriptionCell: UICollectionViewCell {
    
    @IBOutlet weak var continarView: UIView!
    @IBOutlet weak var subcriptionView: UIView!
    @IBOutlet weak var correctImage: UIImageView!
    @IBOutlet weak var pricelabel: UILabel!
    @IBOutlet weak var duriationLabel: UILabel!
    @IBOutlet weak var billedDuriationLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        continarView.borderWidth = 0
        correctImage.isHidden = true
        subcriptionView.backgroundColor = UIColor(red: 200/255, green: 237/255, blue: 255/255, alpha: 1)
        let fontColor = UIColor(red: 44/255, green: 73/255, blue: 247/255, alpha: 1)
        pricelabel.textColor = fontColor
        duriationLabel.textColor = fontColor
        billedDuriationLabel.textColor = fontColor
    }
    
    override var isSelected: Bool{
        didSet{
            
            if isSelected {
                let firstColor = UIColor(red: 118/255, green: 78/255, blue: 232/255, alpha: 1).cgColor
                let secondColor = UIColor(red: 189/255, green: 1/255, blue: 255/255, alpha: 1).cgColor
                continarView.layer.borderWidth = 2
                continarView.layer.borderColor = UIColor.mainColor.cgColor
                correctImage.isHidden = false
                //subcriptionView.applyGradient(colors: [firstColor,secondColor])
                subcriptionView.backgroundColor = UIColor.mainColor
                
                pricelabel.textColor = .white
                duriationLabel.textColor =  .white
                billedDuriationLabel.textColor =  .white
                
            } else {
                continarView.borderWidth = 0
                correctImage.isHidden = true
                subcriptionView.backgroundColor = UIColor(red: 200/255, green: 237/255, blue: 255/255, alpha: 1)
                let fontColor = UIColor(red: 44/255, green: 73/255, blue: 247/255, alpha: 1)
                pricelabel.textColor = fontColor
                duriationLabel.textColor = fontColor
                billedDuriationLabel.textColor = fontColor
            }
        }
    }
}
