//
//  ItemListTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 22/09/2023.
//

import UIKit

class ItemListTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet private weak var itemNameLabel: UILabel!
    @IBOutlet private weak var itemView: UIView!
    @IBOutlet private weak var itemImageView: UIImageView!
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    // MARK: Update
    
    func update(_ item: ItemList) {
        itemNameLabel.text = item.title
        itemImageView.image = item.image
        itemView.backgroundColor = item.backgroundColor
    }
    
}

// MARK: Private Handlers UI

extension ItemListTableViewCell {
    private func configureUI() {
        configureItemLabelUI()
        configureItemViewUI()
    }
    
    private func configureItemLabelUI() {
        itemNameLabel.textColor = .black
        itemNameLabel.font = UIFont.systemFont(ofSize: 15)
    }
    
    private func configureItemViewUI() {
        itemView.layer.cornerRadius = 18
        itemView.layer.borderWidth = 1
        itemView.layer.borderColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1).cgColor
    }
}
