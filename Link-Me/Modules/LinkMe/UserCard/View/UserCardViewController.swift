//
//  UserCardViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit


/// Type of user card .
///
enum UserCardDirection {
    case normal
    case whenSendAddRequest
}

class UserCardViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var heightOfParentViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var reactCardView: ReactCardView!
    @IBOutlet private weak var youLinkWithStackView: UIStackView!
    @IBOutlet private weak var activeButton: UIButton!
    @IBOutlet private weak var unlikeButton: UIButton!
    
    // MARK: - Properties
    
    private let viewModel: UserCardViewModel
    private let coordinator: Coordinator
    private let direction: UserCardDirection
    private let userModel: UserCardModel
    
    // MARK: - Init
    
    init(viewModel: UserCardViewModel, coordinator: Coordinator,
         direction: UserCardDirection, userModel: UserCardModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.direction = direction
        self.userModel = userModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleTypeOfUserCard()
        fillUserData()
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
        switch direction {
        case .normal:
            configureNormalState()
        default:
            break
        }
    }
    
    private func configureNormalState() {
        activeButton.setTitle("Send Link", for: .normal)
        activeButton.setImage(UIImage(named: "link"), for: .normal)
        unlikeButton.isHidden = true
        youLinkWithStackView.isHidden = true
        heightOfParentViewConstraint.constant = 450
    }
    
    private func fillUserData() {
        nameLabel.text = userModel.name
        usernameLabel.text = "@\(String(describing: userModel.username ?? ""))"
        userImageView.setImage(url: URL(string: userModel.imagePath ?? ""))
        reactCardView.setNumberOfLinks(userModel.numberOfLinks)
        reactCardView.setNumberOfFollowing(userModel.numberOfFollowing)
        reactCardView.setNumberOfLikes(userModel.numberOfLikes)
    }
}
