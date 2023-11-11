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
            let signUp = self.coordinator.Auth.viewcontroller(for: .register(code: viewModel.code ?? "", email: viewModel.email ?? ""))
            self.navigationController?.pushViewController(signUp, animated: true)
        case .resetPassword:
            let resetPassword = self.coordinator.Auth.viewcontroller(for: .CreatePassword(code: viewModel.code ?? "", email: viewModel.email ?? ""))
            self.navigationController?.pushViewController(resetPassword, animated: true)
        case .changeEmail:
            print("changeEmail")
        case .none:
            print("ERROR")
            
        }
    }
}
