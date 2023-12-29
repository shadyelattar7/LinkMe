//
//  MessageListViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/12/2023.
//

import UIKit

class MessageListViewController: BaseWireFrame<MessageListViewModel> {

    // MARK: Outlets
    
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var messageRequestButton: UIButton!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var messagesTableView: UITableView!
    
    // MARK: Lifecycle
        
    override func bind(viewModel: MessageListViewModel) {
        configureUI()
        configureTableView()
        subscribeToErrorMessage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getChatRequests()
    }
}

// MARK: Configurations

extension MessageListViewController {
    private func configureUI() {
        editButton.layer.cornerRadius = 18
        countLabel.makeCircleView()
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
    }
}

// MARK: Configure Table view

extension MessageListViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        messagesTableView.registerNIB(cell: MessageListItemCell.self)
        messagesTableView.separatorStyle = .none
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        bindToReloadTableView()
    }
    
    private func reloadTableViewView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.messagesTableView.reloadData()
        }
    }
    
    private func bindToReloadTableView() {
        viewModel.onReloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            self.reloadTableViewView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as MessageListItemCell
        cell.update(viewModel.getItemCell(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatID = viewModel.getItemCell(indexPath: indexPath).id
        let vc = coordinator.Main.viewcontroller(for: .chat(chatID: "\(chatID ?? 0)"))
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
}

// MARK: Private Handlers

extension MessageListViewController {
    private func subscribeToErrorMessage() {
        viewModel.errorMessageObservable.subscribe { [weak self] errorMessage in
            guard let self = self else { return }
            ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
        }.disposed(by: disposeBag)
    }
}
