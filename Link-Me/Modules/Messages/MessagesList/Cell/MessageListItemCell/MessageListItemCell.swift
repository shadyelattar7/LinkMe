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
    @IBOutlet private weak var selectedImageView: UIImageView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateSelectedCell(isSelected: false)
    }
    
    // MARK: Updates
    
    func update(_ item: ChatRequestItem) {
        let cellItem = item.secondUser
        let url = URL(string: cellItem?.imagePath ?? "")
        userImageView.setImage(url: url, placeholder: .placeholder2)
        nameLabel.text = cellItem?.name
    }
    
    func updateHiddenSelectedImageView(isHidden: Bool) {
        selectedImageView.isHidden = isHidden
    }
    
    func updateSelectedCell(isSelected: Bool) {
        switch isSelected {
        case true:
            contentView.backgroundColor = UIColor(red: 0.965, green: 0.957, blue: 1, alpha: 1)
            selectedImageView.image = .EllipseFill
        case false:
            contentView.backgroundColor = .white
            selectedImageView.image = .EllipseEmpty
        }
    }
}

// MARK: Configurations

extension MessageListItemCell {
    private func configureUI() {
        userImageView.makeCircleView()
        countLabel.makeCircleView()
        selectedImageView.isHidden = true
    }
}
