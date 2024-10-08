//
//  FriendsViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 01/03/2024.
//

import UIKit
import RxSwift
import RxCocoa

class FriendsViewController: BaseWireFrame<FriendsViewModel> {

    // MARK: Outlets
    
    @IBOutlet private weak var navigationView: NavigationBarView!
    @IBOutlet private weak var friendsTableView: UITableView!
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    override func bind(viewModel: FriendsViewModel) {
        configureUI()
        configureTableView()
    }
}

// MARK: - Private Handlers

extension FriendsViewController: NavigationBarDelegate {
    private func configureUI() {
        navigationView.configure(with: NavigationBarViewModel(navBarTitle: "Friends"), and: self)
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
}


extension FriendsViewController {
    private func configureTableView() {
        friendsTableView.registerNIB(cell: FriendTableViewCell.self)
        friendsTableView.separatorStyle = .none
        friendsTableView.rx.rowHeight.onNext(98)
        subscribeToProducts()
        didSelectTableViewItem()
    }
    
    private func subscribeToProducts() {
        viewModel.friends.bind(to: friendsTableView.rx.items(cellIdentifier: String(describing: FriendTableViewCell.self), cellType: FriendTableViewCell.self)){ (row, item, cell) in
            
            cell.update(item)
            
        }.disposed(by: disposeBag)
    }
    
    private func didSelectTableViewItem() {
        Observable.zip(friendsTableView.rx.itemSelected, friendsTableView.rx.modelSelected(Friendship.self)).subscribe(onNext:{ [weak self] (indexPath, item) in
            
            guard let self = self else { return }
            coordinator.Main.navigate(for: .chat(chatID: String(item.chatID), chatFrom: .messages))
        }).disposed(by: disposeBag)
    }
}
