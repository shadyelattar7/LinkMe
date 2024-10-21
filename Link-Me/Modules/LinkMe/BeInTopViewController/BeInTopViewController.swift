//
//  BeInTopViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 25/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class BeInTopViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var heightOfParentViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var heightOfUserViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var heightOfUserImageConstraint: NSLayoutConstraint!
    @IBOutlet private weak var widthOfUserImageConstraint: NSLayoutConstraint!
    @IBOutlet private weak var beInTheTopLabel: UILabel!
    @IBOutlet private weak var infoSectionView: UIView!
    @IBOutlet private weak var yourTurnAfterLabel: UILabel!
    @IBOutlet private weak var numberOfUsersLabel: UILabel!
    @IBOutlet private weak var chooseTimeStackView: UIStackView!
    @IBOutlet private weak var chooseTimeLabel: UILabel!
    @IBOutlet private weak var optionsTableView: UITableView!
    @IBOutlet private weak var heightOfOptionsTableViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var niceYouWillBeInTopView: UIView!
    @IBOutlet private weak var numberOfDiamondView: UIView!
    @IBOutlet private weak var numberOfDiamondLabel: UILabel!
    @IBOutlet private weak var thanksButtonView: UIView!
    @IBOutlet private weak var thanksButton: UIButton!
    
    // MARK: - Properties
    
    private let viewModel: BeInTopViewModel
    private let coordinator: Coordinator
    private let disposeBag = DisposeBag()
    private let cardModel: BeInTopModel
    private var numberOfDiamonds: Int?

    // MARK: Init
    
    init(viewModel: BeInTopViewModel, coordinator: Coordinator, cardModel: BeInTopModel) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.cardModel = cardModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFirstViewUI()
        configureTableView()
        setCardData()
        subscribes()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.heightOfOptionsTableViewConstraint.constant = self.optionsTableView.contentSize.height
        }
    }
}

// MARK: - Configure UI

extension BeInTopViewController {
    private func configureFirstViewUI() {
        parentView.layer.cornerRadius = 10
        userImageView.applyBorderStyle(borderColor: .yellow, borderWidth: 2, cornerRadius: 0)
        userImageView.makeCircleView()
        infoSectionView.layer.cornerRadius = 10
        niceYouWillBeInTopView.isHidden = true
        numberOfDiamondView.isHidden = true
        thanksButtonView.isHidden = true
    }
    
    private func configureSecondViewUI(numberOfDiamond: Int) {
        heightOfParentViewConstraint.constant = 580
        heightOfUserImageConstraint.constant = 100
        widthOfUserImageConstraint.constant = 100
        userImageView.layer.cornerRadius = 50
        beInTheTopLabel.isHidden = true
        chooseTimeStackView.isHidden = true
        niceYouWillBeInTopView.isHidden = false
        numberOfDiamondView.isHidden = false
        numberOfDiamondLabel.text = "-\(numberOfDiamond)"
        thanksButtonView.isHidden = false
        thanksButton.applyDefaultStyle(cornerRadius: 10, backgroundColor: .yellow, textColor: UIColor.white)
    }
}

// MARK: - Private handlers

extension BeInTopViewController {
    private func setCardData() {
        let url = URL(string: UDHelper.fetchUserData?.imagePath ?? "")
        self.userImageView.setImage(url: url)
        self.numberOfUsersLabel.text = "\(cardModel.numberOfUsers ?? 0) " + "user".localized
    }
    
    private func subscribes() {
        subscribeToThanksButton()
        subscribeToErrorMessage()
        subscribeToSuccessToBeInTop()
        subscribeToRemaining()
    }
    
    private func subscribeToThanksButton() {
        thanksButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else {return}
            
            self.dismiss(animated: true)
            
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToErrorMessage() {
        viewModel.errorMessageObserver.subscribe { [weak self] errorMessage in
            guard let self = self else { return }
            ToastManager.shared.showToast(message: errorMessage, view: self.view, postion: .top , backgroundColor: .LinkMeUIColor.errorColor)
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToSuccessToBeInTop() {
        viewModel.onSuccessToBeInTop = { [weak self] in
            guard let self = self else { return }
            self.configureSecondViewUI(numberOfDiamond: self.numberOfDiamonds ?? 0)
        }
    }
    
    private func subscribeToRemaining() {
        viewModel.onRemainingChange = { [weak self] in
            guard let self = self else { return }
            self.yourTurnAfterLabel.text = "\(self.viewModel.getRemaining() ?? 0.0)"
        }
    }
}

// MARK: Configure tableView

extension BeInTopViewController {
    private func configureTableView() {
        optionsTableView.registerNIB(cell: ChooseTimeToBeInTopCell.self)
        optionsTableView.separatorStyle = .none
        optionsTableView.delegate = self
        optionsTableView.dataSource = self
    }
}

// MARK: Confirm delegate, dataSource

extension BeInTopViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardModel.stars?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as ChooseTimeToBeInTopCell
        
        guard let model = cardModel.stars?[indexPath.row] else { return UITableViewCell() }
        cell.update(model)
        
        cell.onChange = { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .choose:
                guard let id = model.id else { return }
                self.numberOfDiamonds = model.diamonds
                self.viewModel.updateStarPriceId(id)
                
            case .buy:
                self.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    self.coordinator.Main.navigate(for: .purchases())
                }
            }
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}


