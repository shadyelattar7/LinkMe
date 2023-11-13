//
//  ChatViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 12/11/2023.
//

import UIKit

class ChatViewController: BaseWireFrame<ChatViewModel> {
    
    // MARK: Outlets
    
    @IBOutlet private weak var sendOptionChatView: SendOptionView!
    
    // MARK: Proprites
    
    
    //MARK: - Lifecycle
    
    override func bind(viewModel: ChatViewModel) {
        sendOptionChatViewOutputs()
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
            guard let _ = self else { return }
            print("text", text)
        }
    }
    
    private func onClickAddButton() {
        sendOptionChatView.onClickAdd { [weak self] in
            guard let _ = self else { return }
            // TODO: Need to add action when click on add button.
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
