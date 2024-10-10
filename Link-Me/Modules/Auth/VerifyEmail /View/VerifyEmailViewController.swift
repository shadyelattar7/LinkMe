//
//  VerifyEmailViewController.swift
//  Link-Me
//
//  Created by Al-attar on 14/05/2023.
//

import UIKit

class VerifyEmailViewController: BaseWireFrame<VerifyEmailViewModel>, NavigationBarDelegate{
    
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var email_tf: InputView!
    @IBOutlet weak var VerifyEmail_btn: MainButton!
    @IBOutlet weak var title_lbl: UILabel!
    
    //MARK: - Variables
    
    
    //MARK: - Bind
    
    override func bind(viewModel: VerifyEmailViewModel) {
        setupView()
        subscriptions()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: ""), and: self)
        VerifyEmail_btn.MainBtn.addTarget(self, action: #selector(VerifyEmail), for: .touchUpInside)
        
        switch viewModel.source{
        case .signUp:
            title_lbl.text = "Create New \nAccount".localized
        case .resetPassword:
            title_lbl.text = "Reset \nPassword".localized
        case .changeEmail:
            title_lbl.text = "Create New \nAccount".localized
        case .none:
            print("ERROR")
        
        }
    }
    
    private func subscriptions(){
        viewModel.verifyEmailStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                
                switch self.viewModel.source{
                case .signUp:
                    let createAccount = self.coordinator.Auth.viewcontroller(for: .EnterCode(source: .signUp, email: self.email_tf.text))
                    self.navigationController?.pushViewController(createAccount, animated: true)
                case .resetPassword:
                    let resetPassword = self.coordinator.Auth.viewcontroller(for: .EnterCode(source: .resetPassword, email: self.email_tf.text))
                    self.navigationController?.pushViewController(resetPassword, animated: true)
                case .changeEmail:
                    print("changeEmail")
                case .none:
                    print("ERROR")
               
                }
            }else{
                print("Model: \(model)")
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
            
            
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func VerifyEmail(){
        guard email_tf.validate(for: .email) else {return}
        switch viewModel.source{
        case .signUp:
            viewModel.VerifyEmail(email: email_tf.text, view: self.view)
        case .resetPassword:
            viewModel.VerifyEmailForgetPassword(email: email_tf.text, view: self.view)
        case .changeEmail:
            print("changeEmail")
        case .none:
            print("ERROR")
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
}



