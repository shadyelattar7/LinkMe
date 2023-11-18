//
//  ChatViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import UIKit

class ChatViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var sendOptionChatView: SendOptionView!
    @IBOutlet private weak var chatTableView: UITableView!
    
    // MARK: Proprites
    
    private let viewModel: ChatViewModelType
    private let coordinator: Coordinator
    
    // MARK: Init
    
    init(viewModel: ChatViewModelType, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendOptionChatViewOutputs()
        configureTableView()
        viewModelOutputs()
    }
}


// MARK: Configure Send option chat view

extension ChatViewController {
    private func sendOptionChatViewOutputs() {
        onChangeChatText()
        onClickAddButton()
        onClickCameraButton()
        onClickMicButton()
    }
    
    private func onChangeChatText() {
        sendOptionChatView.onChange { [weak self] text in
            guard let self = self else { return }
            self.viewModel.updateMessageText(text)
        }
    }
    
    private func onClickAddButton() {
        sendOptionChatView.onClickAdd { [weak self] in
            guard let self = self else { return }
            
            /// Send message to firebase and message type.
            ///
            self.viewModel.updateMessageType(.text)
            self.viewModel.sendMessage()
            
            /// Empty again text message to prepare it for next message.
            ///
            self.viewModel.updateMessageText(nil)
            self.sendOptionChatView.makeTextFieldEmpty()
        }
    }
    
    private func onClickCameraButton() {
        sendOptionChatView.onClickCamera { [weak self] in
            guard let _ = self else { return }
            // TODO: Need to add action when click on camera button.
        }
    }
    
    private func onClickMicButton() {
        sendOptionChatView.onClickMic { [weak self] in
            guard let _ = self else { return }
            // TODO: Need to add action when click on mic button.
        }
    }
}


// MARK: Configure table view

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.registerNIB(cell: TextMessageTableViewCell.self)
        chatTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.chatTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as TextMessageTableViewCell
        cell.update(viewModel.getItemCell(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
 

// MARK: ViewModel outputs

extension ChatViewController {
    func viewModelOutputs() {
        onReloadTableView()
    }
    
    private func onReloadTableView() {
        viewModel.onReloadTableView { [weak self] in
            guard let self = self else { return }
            self.reloadTableView()
        }
    }
}
