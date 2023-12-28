//
//  LetsSearchViewController.swift
//  Link-Me
//
//  Created by Ahmed Nasr on 02/10/2023.
//

import UIKit

class LetsSearchViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var letsGoButton: UIButton!
    
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
    
    @IBAction private func didTappedOnLetsGoButton(_ sender: Any) {
//        let vc = coordinator.Main.viewcontroller(for: .startSearch)
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
    }
}

// MARK: - Private Handlers

extension LetsSearchViewController {
    private func configureUI() {
        letsGoButton.applyDefaultStyle(cornerRadius: 8, backgroundColor: .white, textColor: .mainColor)
    }
}
