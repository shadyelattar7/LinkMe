//
//  SearchingForUsersViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import UIKit

class SearchingForUsersViewController: BaseWireFrame<SearchingForUsersViewModel> {

    // MARK: Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var stopSearchingButton: UIButton!
    
    // MARK: LifeCycle
    
    override func bind(viewModel: SearchingForUsersViewModel) {
        configureUI()
        subscribeToErrorMessage()
    }
}

// MARK: - Private handlers

extension SearchingForUsersViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        stopSearchingButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .LinkMeUIColor.lightPurple, textColor: .mainColor)
    }
    
    private func subscribeToErrorMessage() {
        viewModel.errorMessageObserver.subscribe { [weak self] errorMessage in
            guard let self = self else { return }
            ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
        }.disposed(by: disposeBag)
    }
}
