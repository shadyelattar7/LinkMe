//
//  MessageListViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/12/2023.
//

import UIKit
import RxSwift
import RxRelay

class MessageListViewController: BaseWireFrame<MessageListViewModel> {

    // MARK: Outlets
    
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var messageRequestButton: UIButton!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var messagesTableView: UITableView!
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var itemSelectedLabel: UILabel!
    
    // MARK: proprites
    
    private var hiddenSelectedButton: BehaviorRelay<Bool> = .init(value: true)
    private var listOfSelectedChats: [ChatRequestItem] = []
    
    // MARK: Lifecycle
        
    override func bind(viewModel: MessageListViewModel) {
        configureUI()
        configureTableView()
        subscribeToErrorMessage()
        addLongPressToTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getChatRequests()
    }
    
    // MARK: Actions
    
    @IBAction private func didTappedOnEditButton(_ sender: UIButton) {
        self.listOfSelectedChats = []
        if sender.titleLabel?.text == "Edit" {
            makeEditMood()
        } else if sender.titleLabel?.text == "Done" {
            makeNormalMood()
        }
        self.reloadTableView()
    }
    
    @IBAction private func didTappedOnDeletedButton(_ sender: Any) {
        if !listOfSelectedChats.isEmpty {
            var chatsID: [Int] = []
            listOfSelectedChats.forEach { item in
                guard let id = item.id else { return }
                chatsID.append(id)
            }
            let vc = coordinator.Main.viewcontroller(for: .deleteChats(chatsID: chatsID)) as! DeleteChatSheetViewController
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    @IBAction private func didTappedOnFriendsButton(_ sender: Any) {
        let vc = coordinator.Main.viewcontroller(for: .friends)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Configurations

extension MessageListViewController {
    private func makeNormalMood() {
        messagesTableView.allowsMultipleSelectionDuringEditing = false
        messagesTableView.allowsMultipleSelection = false
        hiddenSelectedButton.accept(true)
        editButton.setTitle("Edit", for: .normal)
        bottomView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func makeEditMood() {
        messagesTableView.allowsMultipleSelectionDuringEditing = true
        messagesTableView.allowsMultipleSelection = true
        hiddenSelectedButton.accept(false)
        editButton.setTitle("Done", for: .normal)
        bottomView.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: Add long press to table view to present bottom sheet

extension MessageListViewController {
    private func addLongPressToTableView() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        messagesTableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: messagesTableView)
            if let indexPath = messagesTableView.indexPathForRow(at: touchPoint) {
                guard let chatID = viewModel.getItemCell(indexPath: indexPath).id,
                      let userID = viewModel.getItemCell(indexPath: indexPath).secondUserID else { return }
                let vc: BottomListSheet = coordinator.Main.viewcontroller(for: .BottomListItem(listItems: [.deleteChat, .blockUser(userID: userID)], itemID: chatID)) as! BottomListSheet
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }
    }
}

// MARK: Configurations

extension MessageListViewController {
    private func configureUI() {
        bottomView.isHidden = true
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
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.messagesTableView.reloadData()
        }
    }
    
    private func bindToReloadTableView() {
        viewModel.onReloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            self.reloadTableView()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as MessageListItemCell
        cell.update(viewModel.getItemCell(indexPath: indexPath))
        for index in 0..<listOfSelectedChats.count {
            if self.listOfSelectedChats[index].id == viewModel.getItemCell(indexPath: indexPath).id {
                cell.updateSelectedCell(isSelected: true)
            }
        }
        hiddenSelectedButton.subscribe { isHidden in
            cell.updateHiddenSelectedImageView(isHidden: isHidden)
        }.disposed(by: disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MessageListItemCell
        
        if messagesTableView.allowsMultipleSelection == false {
            let chatID = viewModel.getItemCell(indexPath: indexPath).id
            let vc = coordinator.Main.viewcontroller(
                for: .chat(
                    chatID: "\(chatID ?? 0)",
                    chatFrom: .messages
                )
            )
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        } else {
            self.listOfSelectedChats.append(viewModel.getItemCell(indexPath: indexPath))
            cell.updateSelectedCell(isSelected: true)
        }
        
        itemSelectedLabel.text = "\(listOfSelectedChats.count) Selected"
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MessageListItemCell
        cell.updateSelectedCell(isSelected: false)
        for i in 0..<listOfSelectedChats.count {
            if listOfSelectedChats[i].id == viewModel.getListOfData()[indexPath.row].id {
                self.listOfSelectedChats.remove(at: i)
                break
            }
        }
        
        itemSelectedLabel.text = "\(listOfSelectedChats.count) Selected"
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


// MARK: Delegate to reload messages

extension MessageListViewController: SuccessDeleteChatProtocol {
    func reload() {
        listOfSelectedChats = []
        makeNormalMood()
        viewModel.getChatRequests()
    }
}


// MARK: Delegate

extension MessageListViewController: BottomListDismissedProtocol {
    func dismiss() {
        listOfSelectedChats = []
        makeNormalMood()
        viewModel.getChatRequests()
    }
}
