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
    }
    
    
}
