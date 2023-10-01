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
    @IBOutlet private weak var mySubscriptionStackView: UIStackView!
    @IBOutlet private weak var linkView: UIView!
    @IBOutlet private weak var expiredSubscriptionStackView: UIStackView!
    @IBOutlet private weak var expiredSubscriptionLabel: UILabel!
    @IBOutlet private weak var subscriptionButton: UIButton!
    @IBOutlet private weak var diamondsStoreCollectionView: UICollectionView!
    @IBOutlet private weak var heightOfDiamondsStoreCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var starsStoreCollectionView: UICollectionView!
    @IBOutlet private weak var heightOfStarsStoreCollectionViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var howItWorkButton: UIButton!
    @IBOutlet private weak var privacyButton: UIButton!
    
    // MARK: - LifeCyele
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.heightOfDiamondsStoreCollectionViewConstraint.constant =
            self.diamondsStoreCollectionView.contentSize.height
            self.heightOfStarsStoreCollectionViewConstraint.constant =
            self.starsStoreCollectionView.contentSize.height
        }
    }
}

// MARK: - Private Handlers

extension PurchasesViewController: NavigationBarDelegate {
    private func configureUI() {
        headerView.configure(with: NavigationBarViewModel(navBarTitle: "Purchases"), and: self)
        availableDiamondsView.layer.cornerRadius = 8
        diamondView.makeCircleView()
        mySubscriptionStackView.layer.cornerRadius = 8
        linkView.makeCircleView()
        subscriptionButton.layer.cornerRadius = 8
        howItWorkButton.underline()
        privacyButton.underline()
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Handle collection views

extension PurchasesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func configureCollectionView() {
        diamondsStoreCollectionView.registerNIB(CardStoreCollectionViewCell.self)
        starsStoreCollectionView.registerNIB(CardStoreCollectionViewCell.self)
        diamondsStoreCollectionView.delegate = self
        diamondsStoreCollectionView.dataSource = self
        starsStoreCollectionView.delegate = self
        starsStoreCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case diamondsStoreCollectionView:
            return 4
        default:
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case diamondsStoreCollectionView:
            let cell = collectionView.dequeue(cell: CardStoreCollectionViewCell.self, for: indexPath)
            return cell
            
        default:
            let cell = collectionView.dequeue(cell: CardStoreCollectionViewCell.self, for: indexPath)
            cell.applyStarsStore()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}
