//
//  EmailIsVerifiedViewController.swift
//  Link-Me
//
//  Created by Al-attar on 16/05/2023.
//

import UIKit

class EmailIsVerifiedViewController: BaseWireFrame<EmailIsVerifiedViewModel> {
    //MARK: - @IBOutlet
    
    
    @IBOutlet weak var continue_btn: MainButton!
    
    //MARK: - Variables
    

    //MARK: - Bind
    
    override func bind(viewModel: EmailIsVerifiedViewModel) {
        setupView()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        
        continue_btn.MainBtn.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    //MARK: - Actions

    @objc func continueTapped(){
        
        switch self.viewModel.source{
        case .signUp:
            self.coordinator.Auth.navigate(for: .Register(code: viewModel.code ?? "", email: viewModel.email ?? ""))
        case .resetPassword:
            self.coordinator.Auth.navigate(for: .CreatePassword(code: viewModel.code ?? "", email: viewModel.email ?? ""))
        case .changeEmail:
            print("changeEmail")
        case .none:
            print("ERROR")
        
        }
    }
}
