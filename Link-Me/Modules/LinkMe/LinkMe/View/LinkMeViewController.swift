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
    @IBOutlet private weak var topUserCounterLbl: UILabel!
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTopUsers()
        viewModel.sendFCMToken()
    }
    
    override func bind(viewModel: LinkMeViewModel) {
        configureTableView()
        subscribe()
        didTappedOnNotificationButton()
        didTappedOnPurchasesButton()
        addTappedOnBeInTopView()
        didTappedOnStarsStoreButton()
    }
    
    // MARK: - Actions
    
    @IBAction private func didTappedOnSearchButton(_ sender: Any) {
        let vc = coordinator.Main.viewcontroller(for: .searchType)
        //  vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        viewModel.fetchTopUsers()
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
            if UDHelper.isVistor {
                QuickAlert.showWith(in: self, coordentor: self.coordinator)
            }
            self.coordinator.Main.navigate(for: .notificationList)
        }
    }
    
    private func didTappedOnStarsStoreButton() {
        headerView.clickOnStarsButton = { [weak self] in
            guard let self = self else { return }
            if UDHelper.isVistor {
                QuickAlert.showWith(in: self, coordentor: self.coordinator)
            }
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
        let viewModel = BeInTopViewModel()
        let vc = coordinator.Main.viewcontroller(for: .beInTheTop(viewModel: viewModel, cardModel: model))
        self.present(vc, animated: true)
    }
}


// MARK: Configure top users

extension LinkMeViewController {
    private func configureTableView() {
        topUsersTableView.registerNIB(cell: TopUserTableViewCell.self)
        topUsersTableView.separatorStyle = .none
        topUsersTableView.rx.rowHeight.onNext(80)
        didSelectTopUserItem()
    }
    
    private func subscribeToTopUsersData() {
        viewModel.topUsersObservable.bind(to: topUsersTableView.rx.items(cellIdentifier: String(describing: TopUserTableViewCell.self), cellType: TopUserTableViewCell.self)) { [weak self] (row, item, cell) in
            guard let self = self else { return }
            cell.update(item)
            print(item)
            cell.openProfile = { [weak self] in
                guard let self = self else { return }
                
                let user = self.viewModel.getUserModel(row)
                let userModel = UserCardModel(id: user.id, imagePath: user.imagePath, name: user.name, username: user.user_name, bio: user.bio, numberOfLinks: user.links, numberOfFollowing: user.followers, numberOfLikes: user.likes,can_see_links: user.can_see_links,can_see_followers:user.can_see_followers, can_see_likes:user.can_see_likes)
                
                let vc = self.coordinator.Main.viewcontroller(for: .userCard(direction: .normal, userModel: userModel))
                self.present(vc, animated: true)
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func didSelectTopUserItem() {
        topUsersTableView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            
            // TODO: - Need to handle number of [Links, Following, Likes]
            
            guard let row = indexPath.element?.row else { return }
            let user = self.viewModel.getUserModel(row)
            var chatID: Int = 0
            
            if user.chat_id == nil {
                viewModel.requestChat(userId: user.id ?? 0)
                chatID = viewModel.chatID ?? 0
            } else {
                chatID = user.chat_id ?? 0
            }
            
            let vc = coordinator.Main.viewcontroller(
                for: .chat(
                    chatID: "\(chatID)",
                    chatFrom: .home
                )
            )
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            
        }.disposed(by: disposeBag)
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
