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
    
    func update(_ item: StoryElement) {
        userNameLabel.text = item.name
        guard let imageStr = item.stories else { return }
        if let story = item.stories?.first(where: { $0.video != nil }) {
                // Set video URL
                if let videoURLString = story.video, let videoURL = URL(string: videoURLString) {
                    storyImageView.setImage(url: URL(string: videoURLString))
                }
            }
        guard let userStr = item.imagePath else {return}
        userImageView.setImage(url: URL(string: userStr))
        // TODO: - Need to set story image.
    }
}


// MARK: Private Handlers

extension StoryCollectionViewCell {
    private func configureView() {
        self.layer.cornerRadius = 8
        let borderColors = [UIColor.rgb(red: 118, green: 78, blue: 232).cgColor,
                            UIColor.rgb(red: 255, green: 35, blue: 130).cgColor]
        let borderWidth: CGFloat = 4
        userImageView.applyGradientBorder(colors: borderColors, width: borderWidth)
        userImageView.layer.cornerRadius = 18
    }
}
