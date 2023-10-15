//
//  RequestChatStateViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 04/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

/// Protocol to make action when view controller is dismiss.
///
protocol ViewControllerDismiss: AnyObject {
    func dismiss()
}

class RequestChatStateViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var parentImageUserView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var stateView: UIView!
    @IBOutlet private weak var linkUsersView: LinkUsersImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userAgeLabel: UILabel!
    @IBOutlet private weak var userCountryLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var diamondView: UIView!
    @IBOutlet private weak var requestChatButton: UIButton!
    @IBOutlet private weak var searchAgainButton: UIButton!
    @IBOutlet private weak var diamondCountLabel: UILabel!
    @IBOutlet private weak var timerView: UIView!
    @IBOutlet private weak var activeButton: UIButton!
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: RequestChatStateViewModel
    private let coordinator: Coordinator
    private let requestChatModel: RequestChatModel
    weak var delegate: ViewControllerDismiss?
    private var currentState: RequestChatState? {
        didSet {
            configureCardBasedOnCurrentSate()
        }
    }
    
    // MARK: Init
    
    init(viewModel: RequestChatStateViewModel, coordinator: Coordinator,
         requestChatModel: RequestChatModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.requestChatModel = requestChatModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        currentState = .beforeSendRequest(model: self.requestChatModel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismiss()
    }
    
    // MARK: Actions
    
    @IBAction private func didTappedOnSearchAgainButton(_ sender: Any) {
        delegate?.dismiss()
        dismiss(animated: true)
    }
}

// MARK: Configure UI.

extension RequestChatStateViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        userImageView.makeCircleView()
        stateView.makeCircleView()
        configureLinkUsersView()
        configureButtonUI()
    }
    
    private func configureLinkUsersView() {
        linkUsersView.setSizeOfLeftImage(80)
        linkUsersView.setSizeOfRightImage(80)
        linkUsersView.setSizeOfLinkImage(28)
    }
    
    private func configureButtonUI() {
        requestChatButton.applyDefaultStyle(cornerRadius: 8,
                                            backgroundColor: .mainColor, textColor: .white)
        requestChatButton.centerTextAndImage(spacing: -8)
        searchAgainButton.applyBorderStyle(borderColor: .mainColor,
                                           borderWidth: 1.5, cornerRadius: 8, textColor: .mainColor)
        searchAgainButton.centerTextAndImage(spacing: -8)
    }
}

// MARK: Handle UI detect request chat state.

extension RequestChatStateViewController {
    private func configureCardBasedOnCurrentSate() {
        configureUserImageView()
        configureCardInfo()
        configureDiamond()
        configureTimerView()
        configureActiveButton()
    }
    
    private func configureUserImageView() {
        switch currentState {
        case .beforeSendRequest:
            parentImageUserView.isHidden = false
            linkUsersView.isHidden = true
        default:
            linkUsersView.isHidden = false
            parentImageUserView.isHidden = true
        }
    }
    
    private func configureCardInfo() {
        userImageView.image = currentState?.userImageView
        linkUsersView.setRightImage(currentState?.userImageView ?? UIImage())
        linkUsersView.setLeftImage(currentState?.otherUserImageView ?? UIImage())
        userNameLabel.text = currentState?.userName
        userAgeLabel.text = "\(currentState?.userAge ?? "") y.o"
        userCountryLabel.text = currentState?.userCountry
        descriptionLabel.isHidden = currentState?.descriptionText == nil
        descriptionLabel.text = currentState?.descriptionText
        descriptionLabel.textColor = currentState?.descriptionTextColor
    }
    
    private func configureDiamond() {
        switch currentState {
        case .beforeSendRequest:
            diamondView.isHidden = false
        default:
            diamondView.isHidden = true
        }
    }
    
    private func configureTimerView() {
        switch currentState {
        case .ignoreYourRequest:
            timerView.isHidden = false
        default:
            timerView.isHidden = true
        }
    }
    
    private func configureActiveButton() {
        activeButton.layer.cornerRadius = 8
        activeButton.setTitle(currentState?.activeButtonTitle, for: .normal)
        activeButton.setImage(currentState?.activeButtonImage, for: .normal)
        activeButton.centerTextAndImage(spacing: -8)
        activeButton.backgroundColor = currentState?.activeButtonBackground
        activeButton.setTitleColor(currentState?.activeButtonTextColor, for: .normal)
    }
}
