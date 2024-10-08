//
//  FriendTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 01/03/2024.
//

import UIKit


class FriendTableViewCell: UITableViewCell {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet private weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.makeCircleView()
        statusView.makeCircleView()
    }
    
    // MARK: Updates
    
    func update(_ item: Friendship) {
        userImageView.setImage(url: URL(string: item.friendObj.imagePath ?? ""), placeholder: .placeholder)
        nameLabel.text = item.friendObj.name
        statusLabel.text = item.friendObj.lastSeen
        statusView.backgroundColor = item.friendObj.is_online == 0 ? UIColor(hex: "#A8B9B3") : UIColor(hex: "#1ED597")

    }
}
