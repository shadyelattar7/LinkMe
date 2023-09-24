//
//  NewLinkCardViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 24/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

class NewLinkCardViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var linkUserView: LinkUsersImageView!
    @IBOutlet private weak var sayHiButton: UIButton!
    @IBOutlet private weak var seeProfileButton: UIButton!
    
    // MARK: Properties
    
    private let coordinator: Coordinator
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeViewVisible(view: parentView)
        configureUI()
        subscribeToSayHiButton()
        subscribeToSeeProfileButton()
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
}

// MARK: - Actions

extension NewLinkCardViewController {
    private func subscribeToSayHiButton() {
        sayHiButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let _ = self else {return}
            
            // TODO: - Active Buton action.
            
        }.disposed(by: disposeBag)
    }
    
    private func subscribeToSeeProfileButton() {
        seeProfileButton.rx.tap.throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance).subscribe { [weak self] _ in
            guard let _ = self else {return}
            
            // TODO: Need first dismiss this view then show userCard (can make this with delegate pattern).
            
        }.disposed(by: disposeBag)
    }
}

