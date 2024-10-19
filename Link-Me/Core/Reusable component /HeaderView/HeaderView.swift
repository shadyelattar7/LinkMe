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
    @IBOutlet weak var numberOfDaimons: UILabel!
    @IBOutlet private weak var starBadgeButton: UIButton!
    
    // MARK: - Properties
    
    var clickOnNotificationButton: ()->() = { }
    var clickOnPurchasesButton: ()->() = { }
    var clickOnStarsButton: ()->() = { }
    
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
        print(UDHelper.fetchUserData?.diamonds)
        numberOfDaimons.text = "\(UDHelper.fetchUserData?.diamonds ?? 0 )"
    }
    
    // MARK: - Actions
    
    @IBAction private func didTappedOnNotificationButton(_ sender: Any) {
        clickOnNotificationButton()
    }
    
    @IBAction private func didTappedOnPurchasesButton(_ sender: Any) {
        clickOnPurchasesButton()
    }
    
    @IBAction private func didTappedOnStarsStore(_ sender: Any) {
        clickOnStarsButton()
    }
    
}

// MARK: Private Handlers

extension HeaderView {
    private func configureUI() {
        notificationBadgeButton.makeCircleView()
    }
}

