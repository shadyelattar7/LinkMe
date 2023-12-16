//
//  MessageListItemCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/12/2023.
//

import UIKit

class MessageListItemCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastActiveTimeLabel: UILabel!
    @IBOutlet private weak var lastMessageLabel: UILabel!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: Updates
    
    func update(_ item: ChatRequestItem) {
        let cellItem = item.secondUser
        let url = URL(string: cellItem?.imagePath ?? "")
        userImageView.setImage(url: url)
        nameLabel.text = cellItem?.name
        
    }
}

// MARK: Configurations

extension MessageListItemCell {
    private func configureUI() {
        userImageView.makeCircleView()
        countLabel.makeCircleView()
    }
}
