//
//  TopUserTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 23/09/2023.
//

import UIKit

class TopUserTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var statusView: UIView!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var addButton: UIButton!
    
    // MARK: Proprites
    var openProfile: (()->())?
    
    // MARK: Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func update(_ item: User) {
        nameLabel.text = item.name
        descriptionLabel.text = item.bio ?? ""
        guard let imageStr = item.imagePath, let imageUrl = URL(string: imageStr) else { return }
        userImageView.setImage(url: imageUrl)
        badgeImageView.isHidden = item.is_star == 0 ? true : false
        statusView.isHidden = item.is_online == 0 ? true : false
    }
}

// MARK: Private Handlers

extension TopUserTableViewCell {
    private func configureUI() {
        parentView.layer.cornerRadius = 8
        statusView.makeCircleView()
        userImageView.makeCircleView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userImageViewTapped))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func userImageViewTapped() {
        openProfile?()
    }
}
