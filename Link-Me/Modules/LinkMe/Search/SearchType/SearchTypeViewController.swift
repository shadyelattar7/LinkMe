//
//  SearchTypeViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import UIKit

class SearchTypeViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var startAdvancedSearchButton: UIButton!
    @IBOutlet private weak var startNormalSearchButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - Private handlers

extension SearchTypeViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 8
        startAdvancedSearchButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .mainColor, textColor: .white)
        startAdvancedSearchButton.centerTextAndImage(spacing: -8)
        startNormalSearchButton.applyBorderStyle(borderColor: .strongGray, borderWidth: 2, cornerRadius: 8, textColor: .strongGray)
        cancelButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .lightGray, textColor: .strongGray)
    }
}
