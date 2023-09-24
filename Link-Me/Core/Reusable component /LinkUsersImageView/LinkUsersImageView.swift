//
//  LinkUsersImageView.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit


class LinkUsersImageView: UIView {

    // MARK: - Outlets
    
    @IBOutlet private weak var rightImageView: UIImageView!
    @IBOutlet private weak var leftImageView: UIImageView!
    @IBOutlet private weak var heightOfRightImageConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthOfRightImageConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heightOfLeftImageConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthOfLeftImageConstraint: NSLayoutConstraint!
    
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
}

// MARK: Private Handlers

extension LinkUsersImageView {
    private func configureUI() {
        rightImageView.makeCircleView()
        leftImageView.makeCircleView()
    }
}

// MARK: - Setter & Getter

extension LinkUsersImageView {
    func setRightImage(_ image: UIImage) {
        rightImageView.image = image
    }
    
    func setLeftImage(_ image: UIImage) {
        leftImageView.image = image
    }
    
    func setSizeOfRightImage(_ size: CGFloat) {
        heightOfRightImageConstraint.constant = size
        widthOfRightImageConstraint.constant = size
    }
    
    func setSizeOfLeftImage(_ size: CGFloat) {
        heightOfLeftImageConstraint.constant = size
        widthOfLeftImageConstraint.constant = size
    }
}