//
//  SearchTypeViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 03/10/2023.
//

import UIKit

class SearchTypeViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var parentView: UIView!
    @IBOutlet private weak var startAdvancedSearchButton: UIButton!
    @IBOutlet private weak var startNormalSearchButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - Properties
    
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
    
    @IBAction private func didTappedOnAdvancedSearchButton(_ sender: Any) {
        let vc = coordinator.Main.viewcontroller(for: .filterSearch)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    @IBAction private func didTappedOnNormalSearchButton(_ sender: Any) {
        let vc = coordinator.Main.viewcontroller(for: .SearchingForUsers(requestModel: nil))
        self.present(vc, animated: true)
    }
    
    @IBAction private func didTappedOnCancelButton(_ sender: Any) {
        coordinator.start()
//        dismiss(animated: true)
    }
}

// MARK: - Private handlers

extension SearchTypeViewController {
    private func configureUI() {
        parentView.layer.cornerRadius = 12
        startAdvancedSearchButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .mainColor, textColor: .white)
        startAdvancedSearchButton.centerTextAndImage(spacing: -8)
        startNormalSearchButton.applyBorderStyle(borderColor: .strongGray, borderWidth: 2, cornerRadius: 8, textColor: .strongGray)
        cancelButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .lightGray, textColor: .strongGray)
    }
}
