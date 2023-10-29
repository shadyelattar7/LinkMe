//
//  StartSearchViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 02/10/2023.
//

import UIKit

class StartSearchViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var startSearchingButton: UIButton!
    @IBOutlet private weak var exitButton: UIButton!
    
    // MARK: - Proprites
    
    private let coordinator: Coordinator
    
    // MARK: - Init
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
        configureUI()
    }
    
    // MARK: - Actions
    
    @IBAction private func didTappedOnStartSearchingButton(_ sender: Any) {
        let vc = coordinator.Main.viewcontroller(for: .searchType)
        self.present(vc, animated: true)
    }
    
    @IBAction private func didTappedOnExitButton(_ sender: Any) {
        coordinator.switchToTabBar()
    }
}

// MARK: - Private Handlers

extension StartSearchViewController {
    private func configureUI() {
        startSearchingButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .mainColor, textColor: .white)
        exitButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .lightGray, textColor: .strongGray)
    }
}
