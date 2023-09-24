//
//  NotificationItemTableViewCell.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit

class NotificationItemTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var linkUsersView: LinkUsersImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
}

// MARK: - Private Handlers

extension NotificationItemTableViewCell {
    private func configureUI() {
        linkUsersView.applyBorder()
    }
}
