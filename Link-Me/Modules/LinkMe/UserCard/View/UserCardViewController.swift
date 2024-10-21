//
//  UserCardViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit

class UserCardViewController: BaseWireFrame<UserCardViewModel> {

    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var heightOfParentViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var reactCardView: ReactCardView!
    @IBOutlet weak var youLinkLbl: UILabel!
    @IBOutlet private weak var youLinkWithStackView: UIStackView!
    @IBOutlet private weak var activeButton: UIButton!
    @IBOutlet private weak var unlikeButton: UIButton!
 
    // MARK: - Lifecycle
    override func bind(viewModel: UserCardViewModel) {
        configureUI()
        viewModel.viewDidLoad()
        subscriptions()
        subscriptionAcceptChat()
        subscriptionRefuseChat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleTypeOfUserCard()
    }
    
    @IBAction func dismissBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    //MARK: - Actions
    @IBAction func seyHelloTapped(_ sender: Any) {
        self.viewModel.acceptChatRequest()
    }
    
    @IBAction func unlinkTapped(_ sender: Any) {
        self.viewModel.refuseChatRequest()
    }
    
}

// MARK: - private Handlers
extension UserCardViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        userImageView.makeCircleView()
        activeButton.centerTextAndImage(spacing: -8)
        activeButton.layer.cornerRadius = 8
        unlikeButton.layer.cornerRadius = 8
    }
    
    private func handleTypeOfUserCard() {
        switch viewModel.direction {
        case .profile:
            configureNormalState()
        case .profileWithRequestChat:
            break
        }
    }
    
    private func configureNormalState() {
        activeButton.setTitle("   Let's Talk".localized, for: .normal)
        activeButton.setImage(UIImage(named: "Chat"), for: .normal)
        unlikeButton.isHidden = true
        youLinkWithStackView.isHidden = true
        heightOfParentViewConstraint.constant = 450
    }
    
    private func subscriptions() {
        viewModel.oneUsersModel.subscribe { [weak self] userModel in
            guard let self = self, let userModel = userModel.element else {return}
            nameLabel.text = userModel.name
            youLinkLbl.text = "You linked with".localized + " \(userModel.name ?? "")"
            usernameLabel.text = "@\(String(describing: userModel.user_name ?? ""))"
            descriptionLabel.text = userModel.bio
            userImageView.setImage(url: URL(string: userModel.imagePath ?? ""))
            reactCardView.setNumberOfLinks(userModel.links)
            reactCardView.setNumberOfFollowing(userModel.followers)
            reactCardView.setNumberOfLikes(userModel.likes)
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
    
    private func subscriptionRefuseChat() {
        viewModel.refuseChat.subscribe { [weak self] response in
            guard let self = self, let response = response.element else { return }
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
