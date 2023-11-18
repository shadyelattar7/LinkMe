//
//  ImageMessageTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 18/11/2023.
//

import UIKit
import SDWebImage

class ImageMessageTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet private weak var messageStackView: UIStackView!
    @IBOutlet private weak var messageImageView: UIImageView!
    @IBOutlet private weak var heightOfImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthOfImageViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timeLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    // MARK: Updates
    
    func update(_ item: MessageModel) {
        messageImageView.image = nil
        messageImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
        messageImageView.sd_setImage(with: URL(string: item.messages?.path ?? ""))
        updateUI(item)
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
