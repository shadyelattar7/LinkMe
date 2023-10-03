//
//  AgeCollectionViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import UIKit

class AgeCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var ageLabel: UILabel!
    
    // MARK: LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: Usage functions
    
    func update(_ item: String) {
        ageLabel.text = item
    }
    
    func selectItem() {
        parentView.backgroundColor = .LinkMeUIColor.lightPurple
        parentView.layer.borderColor = UIColor.mainColor.cgColor
        parentView.layer.borderWidth = 2
        ageLabel.textColor = .LinkMeUIColor.mainColor
    }
    
    func unSelectItem() {
        parentView.backgroundColor = .LinkMeUIColor.lightGray
        parentView.layer.borderColor = UIColor.lightGray.cgColor
        ageLabel.textColor = .LinkMeUIColor.strongGray
    }
}

// MARK: Private Handlers

extension AgeCollectionViewCell {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
    }
}

