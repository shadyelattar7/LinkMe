//
//  FriendTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 01/03/2024.
//

import UIKit

struct FriendModel {
    var id: Int
    var imagePath: String?
    var name: String?
    var status: String?
}
class FriendTableViewCell: UITableViewCell {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.makeCircleView()
    }
    
    // MARK: Updates
    
    func update(_ item: FriendModel) {
        userImageView.setImage(url: URL(string: item.imagePath ?? ""), placeholder: .placeholder)
        nameLabel.text = item.name
        statusLabel.text = item.status
    }
}
