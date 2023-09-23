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
}


// MARK: Configure top users

extension LinkMeViewController {
    private func configureTableView() {
        topUsersTableView.registerNIB(cell: TopUserTableViewCell.self)
        topUsersTableView.separatorStyle = .none
        topUsersTableView.rx.rowHeight.onNext(90)
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
            guard let _ = self else {return}

            // MARK: Handle if click on user item.

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
