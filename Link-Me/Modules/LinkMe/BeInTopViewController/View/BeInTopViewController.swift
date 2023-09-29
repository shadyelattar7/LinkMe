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
    
    private let disposeBag = DisposeBag()
    private let cardModel: BeInTopModel
    
    // MARK: Init
    
    init(cardModel: BeInTopModel) {
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
        self.numberOfUsersLabel.text = "\(cardModel.numberOfUsers ?? 0) user"
    }
    
    private func subscribes() {
        subscribeToThanksButton()
    }
    
    private func subscribeToThanksButton() {
        thanksButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let self = self else {return}
            
            self.dismiss(animated: true)
            
        }.disposed(by: disposeBag)
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
                // TODO: - Need to call api that make this user in the top after that change view ui.
                self.configureSecondViewUI(numberOfDiamond: model.diamonds ?? 0)
                
            case .buy:
                // TODO: - Need to go to market to buy diamond.
                break
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


