//
//  HeaderView.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 23/09/2023.
//

import UIKit

class HeaderView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var notificationBadgeButton: UILabel!
    
    // MARK: - Properties
    
    var clickOnNotificationButton: ()->() = { }
    
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        loadViewFromNib()
        configureUI()
    }
    
    // MARK: - Actions
    
    @IBAction private func didTappedOnNotificationButton(_ sender: Any) {
        clickOnNotificationButton()
    }
}

// MARK: Private Handlers

extension HeaderView {
    private func configureUI() {
        notificationBadgeButton.makeCircleView()
    }
}

