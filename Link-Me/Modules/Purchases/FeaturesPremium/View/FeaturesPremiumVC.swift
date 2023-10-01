//
//  FeaturesPremiumVC.swift
//  Link-Me
//
//  Created by Al-attar on 23/09/2023.
//

import UIKit

class FeaturesPremiumVC: BaseWireFrame<FeaturesPremiumViewModel> {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var GoPremiumBtn: MainButton!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - Bind
    override func bind(viewModel: FeaturesPremiumViewModel) {
        setupView()
    }
    
    //MARK: - Private func
    private func setupView(){
        GoPremiumBtn.MainBtn.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    //MARK: - Actions
    @objc func saveTapped(){
       print("Go Premium")
        self.coordinator.Main.navigate(for: .GoPremium)
        self.dismiss(animated: true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
