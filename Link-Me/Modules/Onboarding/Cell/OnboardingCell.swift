//
//  OnboardingCell.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import UIKit


class OnboardingCell: UICollectionViewCell {

    @IBOutlet weak var onboardingImage_iv: UIImageView!
    @IBOutlet weak var title_lbl: UILabel!
    @IBOutlet weak var contant_lbl: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pageControl.numberOfPages = 3
    }

    
    func configure(item: onboardingitems){
        onboardingImage_iv.image = item.image
        title_lbl.text = item.title
        contant_lbl.text = item.subTitle
    }
    
    
}



