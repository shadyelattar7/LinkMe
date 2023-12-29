//
//  TextMessageTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 18/11/2023.
//

import UIKit

class TextMessageTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet private weak var messageStackView: UIStackView!
    @IBOutlet private weak var messageView: UIView!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var timeLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    // MARK: Updates
    
    func update(_ item: MessageModel) {
        messageTextView.text = item.messages?.content
        timeLabel.text = item.messages?.createdAt
        updateUI(item)
    }
    
    private func updateUI(_ item: MessageModel) {
        guard let senderID = UDHelper.fetchUserData?.id else { return }
        
        if "\(senderID)" == item.SenderID {
            
            semanticContentAttribute = .forceRightToLeft
            messageTextView.textAlignment = .right
            messageTextView.textColor = .white
            messageView.backgroundColor = .mainColor
            messageStackView.alignment = .trailing
            
        } else {
            semanticContentAttribute = .forceLeftToRight
            messageTextView.textAlignment = .left
            messageTextView.textColor = .strongGray
            messageView.backgroundColor = .lightGray
            messageStackView.alignment = .leading
        }
    }
}

