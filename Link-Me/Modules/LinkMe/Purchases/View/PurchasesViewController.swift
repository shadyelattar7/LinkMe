//
//  PurchasesViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 01/10/2023.
//

import UIKit

class PurchasesViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var headerView: NavigationBarView!
    @IBOutlet private weak var availableDiamondsView: UIView!
    @IBOutlet private weak var diamondView: UIView!
    @IBOutlet private weak var numberOfDiamondLabel: UILabel!
    @IBOutlet private weak var mySubscriptionView: UIView!
    @IBOutlet private weak var linkView: UIView!
    
    // MARK: - LifeCyele
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Private Handlers

extension PurchasesViewController: NavigationBarDelegate {
    private func configureUI() {
        headerView.configure(with: NavigationBarViewModel(navBarTitle: "Purchases"), and: self)
        availableDiamondsView.layer.cornerRadius = 8
        diamondView.makeCircleView()
        mySubscriptionView.layer.cornerRadius = 8
        linkView.makeCircleView()
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}
