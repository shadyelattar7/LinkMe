//
//  StoryCollectionViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/09/2023.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {

    // MARK: Outlets
    
    @IBOutlet private weak var storyImageView: UIImageView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    
    // MARK: Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureView()
    }
    
    // MARK: Configuration
    
    func update(_ item: UserStoryData) {
        userNameLabel.text = item.name
        guard let imageStr = item.imagePath else { return }
        userImageView.setImage(url: URL(string: imageStr))
        // TODO: - Need to set story image.
        storyImageView.setImage(url: URL(string: imageStr))
    }
}


// MARK: Private Handlers

extension StoryCollectionViewCell {
    private func configureView() {
        self.layer.cornerRadius = 8
        let borderColors = [UIColor.rgb(red: 118, green: 78, blue: 232).cgColor,
                            UIColor.rgb(red: 255, green: 35, blue: 130).cgColor]
        let borderWidth: CGFloat = 4
        userImageView.addGradientBorder(colors: borderColors, width: borderWidth)
        userImageView.layer.cornerRadius = 18
    }
}
