//
//  DeleteChatSheetViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 16/01/2024.
//

import UIKit

protocol SuccessDeleteChatProtocol: AnyObject {
    func reload()
}

class DeleteChatSheetViewController: BaseWireFrame<DeleteChatSheetViewModel> {

    // MARK: Outlets
    
    @IBOutlet private weak var itemsParentView: UIView!
    @IBOutlet private weak var handView: UIView!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    // MARK: Properties
    
    weak var delegate: SuccessDeleteChatProtocol?
    
    // MARK: Lifecycle
    
    override func bind(viewModel: DeleteChatSheetViewModel) {
        configureUI()
        subscribeToScreenState()
    }
    
    // MARK: Actions
    
    @IBAction private func didTappedOnDeleteButton(_ sender: Any) {
        viewModel.deleteChats()
    }
    
    @IBAction private func didTappedOnCancelButton(_ sender: Any) {
        self.delegate?.reload()
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


// MARK: ViewModel Outputs

extension DeleteChatSheetViewController {
    private func subscribeToScreenState() {
        viewModel.screenStateObserver.subscribe { [weak self] state in
            guard let self = self else { return }
            
            switch state.element {
            case .success:
                self.delegate?.reload()
                self.dismiss(animated: true)
                
            case .error(let errorMessage):
                ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
            default:
                break
            }
            
        }.disposed(by: disposeBag)
    }
}
