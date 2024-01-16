//
//  DeleteChatSheetViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/01/2024.
//

import UIKit

class DeleteChatSheetViewController: BaseWireFrame<DeleteChatSheetViewModel> {

    // MARK: Outlets
    
    @IBOutlet private weak var itemsParentView: UIView!
    @IBOutlet private weak var handView: UIView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // MARK: Properties
    
    
    // MARK: Lifecycle
    
    override func bind(viewModel: DeleteChatSheetViewModel) {
        configureUI()
    }
    
    // MARK: Actions
    
    @IBAction private func didTappedOnDeleteButton(_ sender: Any) {
        // TODO: - Call api to delete chats
    }
    
    @IBAction private func didTappedOnCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
}


// MARK: Configure UI

extension DeleteChatSheetViewController {
    private func configureUI() {
        itemsParentView.layer.cornerRadius = 12
        subtitleLabel.text = "Delete \(viewModel.getNumberOfChats()) chat"
        configureHandViewUI()
    }
    private func configureHandViewUI() {
        handView.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        handView.layer.cornerRadius = 5
    }
}
