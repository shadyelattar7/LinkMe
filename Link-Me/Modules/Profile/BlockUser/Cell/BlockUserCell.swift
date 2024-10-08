//
//  BlockUserCell.swift
//  Link-Me
//
//  Created by Ahmed Eltrass on 23/07/2024.
//

import UIKit

class BlockUserCell: UITableViewCell {
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet weak var unBlockOutlet: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var statusLabel: UILabel!
    var unblockUser: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unBlockOutlet.setTitle("Unblock".localized, for: .normal)
    }
    func update(_ item: User) {
        userImageView.setImage(url: URL(string: item.imagePath ?? ""), placeholder: .placeholder)
        nameLabel.text = item.name
        statusLabel.text = item.last_availablity?.toDate(format: .yearMonthDay)?.timeAgoDisplay()
        print(item.last_availablity?.toDate(format: .yearMonthDay)?.timeAgoDisplay())
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func unblockBtn(_ sender: Any) {
        unblockUser?()
    }
    
}
