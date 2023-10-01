//
//  CardStoreCollectionViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 01/10/2023.
//

import UIKit

class CardStoreCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var imageParentView: UIView!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var hintLabel: UILabel!
    @IBOutlet private weak var subLabel: UILabel!
    
    // MARK: LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func applyStarsStore() {
        parentView.backgroundColor = .lightYellow
        mainImageView.image = UIImage(named: "yellowBadge")
        subLabel.textColor = .yellow
    }
}

// MARK: - Private Handlers

extension CardStoreCollectionViewCell {
    private func configureUI() {
        parentView.layer.cornerRadius = 8
        imageParentView.makeCircleView()
    }
}
