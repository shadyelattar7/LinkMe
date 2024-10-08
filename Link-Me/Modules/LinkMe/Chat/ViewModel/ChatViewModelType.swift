//
//  ChatViewModelType.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 18/11/2023.
//

import Foundation


typealias ChatViewModelType = ChatViewModelInputs & ChatViewModelOutputs

// MARK: ChatViewModel Inputs

protocol ChatViewModelInputs {
    func updateMessageType(_ type: ChatMessageType)
    func updateMediaMessageType(_ type: ChatMessageMediaType)
    func updateMessageText(_ text: String?)
    func updateMediaData(_ data: Data?)
}

// MARK: ChatViewModel Outputs

protocol ChatViewModelOutputs {
    var numberOfCells: Int { get }
    func getItemCell(indexPath: IndexPath) -> MessageModel
    func onReloadTableView(reload: @escaping () -> Void)
    func onChangeError(error: @escaping (String) -> Void)
    func fetchMessages()
    func sendMessage(completion: @escaping ((Bool) -> Void))
}
