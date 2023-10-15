//
//  SearchingForUsersViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class SearchingForUsersViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var stopSearchingButton: UIButton!
    
    // MARK: Properties
    
    private let viewModel: SearchingForUsersViewModel
    private let coordinator: Coordinator
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(viewModel: SearchingForUsersViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        subscribe()
    }
}

// MARK: - Private handlers

extension SearchingForUsersViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        stopSearchingButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .LinkMeUIColor.lightPurple, textColor: .mainColor)
    }
    
    private func subscribe() {
        subscribeToSelectedUser()
        subscribeToErrorMessage()
    }
    
    private func subscribeToErrorMessage() {
        viewModel.errorMessageObserver.subscribe { [weak self] errorMessage in
            guard let self = self else { return }
            ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToSelectedUser() {
        
        viewModel.bindToOpenSearchClosure = { [weak self] in
            guard let self = self else { return }
            guard let vc = self.coordinator.Main.viewcontroller(for: .requestChatState(requestChatModel: self.viewModel.generateRequestChatModel())) as? RequestChatStateViewController else { return }
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
}

// MARK: Confirm deledate

extension SearchingForUsersViewController: ViewControllerDismiss {
    func dismiss() {
        viewModel.fetchRandomUser()
    }
}
