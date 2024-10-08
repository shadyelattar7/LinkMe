//
//  ImageMessageTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 18/11/2023.
//

import UIKit
import SDWebImage
import AVFoundation

class ImageMessageTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet private weak var messageStackView: UIStackView!
    @IBOutlet private weak var messageImageView: UIImageView!
    @IBOutlet private weak var heightOfImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthOfImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet weak var oneTimeView: UIView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: Updates
    
    func update(_ item: MessageModel) {
        messageImageView.image = nil
        
        if item.messages?.type == .image {
            messageImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
            messageImageView.sd_setImage(with: URL(string: item.messages?.path ?? ""))
        } else {
            if let videoStr = item.messages?.path, let url = URL(string: videoStr){
                if url.pathExtension == "mp4" || url.pathExtension == "mov" || url.pathExtension == "m4v" {
                    generateThumbnail(url: url) { [weak self] image in
                        guard let self = self, let thumbnailImage = image else { return }
                        print("thumbnailImage: \(thumbnailImage)")
                        self.messageImageView.image = thumbnailImage
                    }
                }
            }
        }
        
        timeLabel.text = item.messages?.createdAt
        messageImageView.isHidden = item.messages?.one_time == 1 ? true : false
        oneTimeView.isHidden = item.messages?.one_time == 0 ? true : false
        updateUI(item)
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
    
    private func updateUI(_ item: MessageModel) {
        guard let senderID = UDHelper.fetchUserData?.id else { return }
        
        if "\(senderID)" == item.SenderID {
            
            semanticContentAttribute = .forceRightToLeft
            messageStackView.alignment = .trailing
            
        } else {
            semanticContentAttribute = .forceLeftToRight
            messageStackView.alignment = .leading
        }
    }
}
