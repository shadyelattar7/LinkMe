//
//  StoryCollectionViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 20/09/2023.
//

import UIKit
import AVFoundation

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
        if let videoStr = item.stories?.first?.video, let url = URL(string: videoStr) {
            if url.pathExtension == "mp4" || url.pathExtension == "mov" || url.pathExtension == "m4v" {
                // It's a video, generate thumbnail
                generateThumbnail(url: url) { [weak self] image in
                    guard let self = self, let thumbnailImage = image else { return }
                    self.storyImageView.image = thumbnailImage
                }
            } else {
                storyImageView.setImage(url: url)
            }
        }
        
        if let userStr = item.imagePath {
            userImageView.setImage(url: URL(string: userStr))
        }
    }
    
    private func generateThumbnail(url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            assetImageGenerator.appliesPreferredTrackTransform = true
            
            let time = CMTime(seconds: 1, preferredTimescale: 600)
            do {
                let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(image)
                }
            } catch {
                print("Failed to generate thumbnail: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
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
