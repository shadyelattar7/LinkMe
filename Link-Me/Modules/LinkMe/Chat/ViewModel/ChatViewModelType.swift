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
    func updateMessageType(_ type: MessageType)
    func updateMessageText(_ text: String?)
    func updateImageData(_ data: Data?)
    func updateAudioPath(_ path: String?)
}

// MARK: ChatViewModel Outputs

protocol ChatViewModelOutputs {
    var numberOfCells: Int { get }
    func getItemCell(indexPath: IndexPath) -> MessageModel
    func onReloadTableView(reload: @escaping () -> Void)
    func fetchMessages()
    func sendMessage()
    func uploadImageToStorage()
    func uploadAudioToStorage()
}
