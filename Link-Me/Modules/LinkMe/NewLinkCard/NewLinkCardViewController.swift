//
//  NewLinkCardViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit

class NewLinkCardViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var linkUserView: LinkUsersImageView!
    @IBOutlet private weak var sayHiButton: UIButton!
    @IBOutlet private weak var seeProfileButton: UIButton!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewVisible(view: parentView)
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showViewFromTop(view: parentView)
    }
}

// MARK: - private Handlers

extension NewLinkCardViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        sayHiButton.applyButtonStyle(.primary)
        seeProfileButton.applyButtonStyle(.border)
    }
}


