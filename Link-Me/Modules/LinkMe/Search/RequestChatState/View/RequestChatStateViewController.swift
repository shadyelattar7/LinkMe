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
        updateRequestChatModel()
        subscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismiss()
    }
    
    // MARK: Actions
    
    
    @IBAction private func didTappedOnRequestChatButton(_ sender: Any) {
        currentState = .waitingForResponse(model: self.requestChatModel)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.viewModel.requestChat()
        }
    }
    
    @IBAction private func didTappedOnSearchAgainButton(_ sender: Any) {
        delegate?.dismiss()
        dismiss(animated: true)
    }
    

    @IBAction func didTappedActiveButton(_ sender: Any) {
        if UDHelper.isVistor {
            QuickAlert.showWith(in: self, coordentor: self.coordinator)
        }
        switch currentState {
        case .acceptYourRequest:
            let vc = coordinator.Main.viewcontroller(for: .chat(chatID: viewModel.getChatID()))
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        default:
            break
        }
    }
}

// MARK: Configurations.

extension RequestChatStateViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        userImageView.makeCircleView()
        stateView.makeCircleView()
        configureLinkUsersView()
        configureButtonUI()
    }
    
    private func updateRequestChatModel() {
        let model = RequestChatRequestModel(userId: requestChatModel.userId, message: "", isSpecial: requestChatModel.isSpecialSearch)
        viewModel.updateRequestChatRequestModel(model)
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
        userImageView.image = currentState?.targetUserImageView
        linkUsersView.setRightImage(currentState?.currentUserImageView ?? UIImage())
        linkUsersView.setLeftImage(currentState?.targetUserImageView ?? UIImage())
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


// MARK: Handle api

extension RequestChatStateViewController {
    private func subscribe() {
        subscribeToErrorMessage()
        subscribeToRequestChatResponse()
    }
    
    private func subscribeToErrorMessage() {
        viewModel.errorMessageObserver.subscribe { [weak self] errorMessage in
            guard let self = self else { return }
            ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToRequestChatResponse() {
        viewModel.bindTosubscribeRequestClosure = { [weak self] status in
            guard let self = self else { return }
            if status == 1 { //accpet
                self.currentState = .acceptYourRequest(model: self.requestChatModel)
            } else if status == 0 { //ignore
                self.currentState = .ignoreYourRequest(model: self.requestChatModel)
            }
        }
    }
}
