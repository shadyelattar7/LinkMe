//
//  BeInTopView.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 23/09/2023.
//

import UIKit


class BeInTopView: UIView {
    
    // MARK: Outlets
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var starView: UIView!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
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

extension BeInTopView {
    private func configureUI() {
        parentView.layer.cornerRadius = 8
        parentView.applyGradient(colors: [UIColor.yellow.cgColor, UIColor.yellowLight.cgColor])
        starView.makeCircleView()
    }
}
