//
//  ReactCardView.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit


class ReactCardView: UIView {
    
    
    @IBOutlet private weak var parentView: UIView!
    
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

extension ReactCardView {
    private func configureUI() {
        parentView.layer.cornerRadius = 10
    }
}
