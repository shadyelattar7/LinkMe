//
//  NewLinkCardViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class NewLinkCardViewController: BaseWireFrame<NewLinkCardViewModel> {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var linkUserView: LinkUsersImageView!
    @IBOutlet private weak var sayHiButton: UIButton!
    @IBOutlet private weak var seeProfileButton: UIButton!
    
    // MARK: Properties
    
    
    // MARK: - LifeCycle
    override func bind(viewModel: NewLinkCardViewModel) {
        viewModel.viewDidLoad()
        subscriptions()
        makeViewVisible(view: parentView)
        configureUI()
        subscribeToSayHiButton()
        subscribeToSeeProfileButton()
        configureLinkUsersView()
        subscriptionAcceptChat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showViewFromTop(view: parentView)
    }
}

// MARK: - private Handlers

extension NewLinkCardViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        sayHiButton.applyButtonStyle(.primary)
        seeProfileButton.applyButtonStyle(.border)
    }
    
    private func subscriptions() {
        viewModel.oneUsersModel.subscribe { [weak self] user in
            guard let self = self, let user = user.element else {return}
            
            linkUserView.setLeftImageFromURL(UDHelper.fetchUserData?.imagePath ?? "")
            
            linkUserView.setRightImageFromURL(user.imagePath ?? "")
            
        }.disposed(by: disposeBag)
    }
    
    private func subscriptionAcceptChat() {
        viewModel.acceptChat.subscribe { [weak self] response in
            guard let self = self, let response = response.element else { return }
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: { [weak self] in
                // Get Top Controller With Extension
                let topController = UIApplication.topViewController()
                // Pressent New Controller over top controller
                guard let vc = self?.coordinator.Main.viewcontroller(for: .chat(chatID: "\(self?.viewModel.chatID ?? 0)", chatFrom: .search)) else { return }
                vc.modalPresentationStyle = .overFullScreen
                topController?.present(vc, animated: true, completion: nil)
            })
        }.disposed(by: disposeBag)
    }
    
    private func configureLinkUsersView() {
        linkUserView.setSizeOfLeftImage(60)
        linkUserView.setSizeOfRightImage(60)
        linkUserView.setSizeOfLinkImage(22)
    }
}

// MARK: - Actions

extension NewLinkCardViewController {
    private func subscribeToSayHiButton() {
        sayHiButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else {return}
            self.viewModel.acceptChatRequest()
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToSeeProfileButton() {
        seeProfileButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else {return}
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: { [weak self] in
                // Get Top Controller With Extension
                let topController = UIApplication.topViewController()
                // Pressent New Controller over top controller
                guard let congratsPopup = self?.coordinator.Main.viewcontroller(for: .userCard(userID: self?.viewModel.userID ?? 0, chatID: self?.viewModel.chatID ?? 0, direction: .profileWithRequestChat)) else { return }
                topController?.present(congratsPopup, animated: true, completion: nil)
            })
        }.disposed(by: disposeBag)
    }
}

