//
//  RequestChatStateViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 04/10/2023.
//

import UIKit

class RequestChatStateViewController: BaseWireFrame<RequestChatStateViewModel> {

    
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
    
    private var currentState: RequestChatState? {
        didSet {
            configureCardBasedOnCurrentSate()
        }
    }
    
    // MARK: LifeCycle
    
    override func bind(viewModel: RequestChatStateViewModel) {
        configureUI()
        
        let model = RequestChatModel(userImageView: UIImage(named: "Group 62726")!, otherImageView: UIImage(named: "Group 62726")!, userName: "Ahmed Nasr", userAge: "25", userCountry: "Egypt")
        
        currentState = .beforeSendRequest(model: model)
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
