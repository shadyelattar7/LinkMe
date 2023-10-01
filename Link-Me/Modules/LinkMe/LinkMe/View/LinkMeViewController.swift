//
//  LinkMeViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 23/09/2023.
//

import UIKit

class LinkMeViewController: BaseWireFrame<LinkMeViewModel> {
    
    // MARK: Outlets
    
    @IBOutlet private weak var headerView: HeaderView!
    @IBOutlet private weak var topYellowView: BeInTopView!
    @IBOutlet private weak var topUsersTableView: UITableView!
    @IBOutlet private weak var heightOfTableViewConstraint: NSLayoutConstraint!
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTopUsers()
    }
    
    override func bind(viewModel: LinkMeViewModel) {
        configureTableView()
        subscribe()
        didTappedOnNotificationButton()
        didTappedOnPurchasesButton()
        addTappedOnBeInTopView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.heightOfTableViewConstraint.constant = self.topUsersTableView.contentSize.height + 120
        }
    }
}


// MARK: Private Handlers

extension LinkMeViewController {
    private func subscribe() {
        subscribeToTopUsersData()
        subscribeToErrorMessage()
    }
    
    private func didTappedOnNotificationButton() {
        headerView.clickOnNotificationButton = { [weak self] in
            guard let self = self else { return }
            
            self.coordinator.Main.navigate(for: .notificationList)
        }
    }
    
    private func didTappedOnPurchasesButton() {
        headerView.clickOnPurchasesButton = { [weak self] in
            guard let self = self else { return }
            
            self.coordinator.Main.navigate(for: .purchases)
        }
    }
    
    private func addTappedOnBeInTopView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTappedOnBeInTopView))
        tap.numberOfTapsRequired = 1
        topYellowView.isUserInteractionEnabled = true
        topYellowView.addGestureRecognizer(tap)
    }
    
    @objc private func didTappedOnBeInTopView() {
        let model = viewModel.getBeInTopModel()
        let vc = coordinator.Main.viewcontroller(for: .beInTheTop(cardModel: model))
        self.present(vc, animated: true)
    }
}


// MARK: Configure top users

extension LinkMeViewController {
    private func configureTableView() {
        topUsersTableView.registerNIB(cell: TopUserTableViewCell.self)
        topUsersTableView.separatorStyle = .none
        topUsersTableView.rx.rowHeight.onNext(90)
        didSelectTopUserItem()
    }
    
    private func subscribeToTopUsersData() {
        viewModel.topUsersObservable.bind(to: topUsersTableView.rx.items(cellIdentifier: String(describing: TopUserTableViewCell.self), cellType: TopUserTableViewCell.self)) { [weak self] (row, item, cell) in

            guard let self = self else { return }
            self.configureTableViewHeight()
            cell.update(item)
            
        }.disposed(by: disposeBag)
    }

    private func didSelectTopUserItem() {
        topUsersTableView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }

            // TODO: - Need to handle number of [Links, Following, Likes]
            
            guard let row = indexPath.element?.row else { return }
            let user = self.viewModel.getUserModel(row)
            let userModel = UserCardModel(id: user.id, imagePath: user.imagePath, name: user.name, username: user.user_name, bio: user.bio, numberOfLinks: 0, numberOfFollowing: 0, numberOfLikes: 0)
            
            let vc = self.coordinator.Main.viewcontroller(for: .userCard(direction: .normal, userModel: userModel))
            self.present(vc, animated: true)
            
        }.disposed(by: disposeBag)
    }
    
    private func configureTableViewHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.heightOfTableViewConstraint.constant = self.topUsersTableView.contentSize.height + 120
        }
    }
}

// MARK: ViewModel Outputs and Inputs

extension LinkMeViewController {
    private func subscribeToErrorMessage() {
        viewModel.errorMessageObservable.subscribe { [weak self] errorMessage in
            guard let self = self else { return }
            ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
        }.disposed(by: disposeBag)
    }
}
