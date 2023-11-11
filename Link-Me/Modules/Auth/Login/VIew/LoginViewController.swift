//
//  LoginViewController.swift
//  Link-Me
//
//  Created by Al-attar on 13/05/2023.
//

import UIKit

class LoginViewController: BaseWireFrame<LoginViewModel> {
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var email_tf: InputView!
    @IBOutlet weak var password_tf: InputView!
    @IBOutlet weak var forget_btn: UIButton!
    @IBOutlet weak var skip_btn: UIButton!
    @IBOutlet weak var login_btn: MainButton!
    @IBOutlet weak var create_btn: MainButton!
    
    //MARK: - Variables
    
    
    //MARK: - Bind
    
    override func bind(viewModel: LoginViewModel) {
        setupView()
        subscriptions()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        skip_btn.underline()
        login_btn.MainBtn.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        create_btn.MainBtn.addTarget(self, action: #selector(createTapped), for: .touchUpInside)

        skip_btn.isHidden = UDHelper.isVistor
    }
    
    private func subscriptions(){
        viewModel.loginStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("GOOOOOOOO!! 🚀🚀🚀")
                if UDHelper.isVistorLoggedIn {
                    self.dismiss(animated: true) {
                        self.coordinator.switchToTabBar()
                        UDHelper.isVistorLoggedIn = false
                    }
                } else {
                    self.coordinator.start()
                }
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
        
        viewModel.loginAsVistorStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("GOOOOOOOO!! 🚀🚀🚀")
                self.coordinator.start()
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
        
    }
    
    //MARK: - Actions
    
    @IBAction func skipTapped(_ sender: Any) {
        UDHelper.isSkip = true
        self.viewModel.loginAsVistor(view: self.view)
    }
    
    
    @IBAction func forgetTapped(_ sender: Any) {
        let forgetPassword = self.coordinator.Auth.viewcontroller(for: .VerifyEmail(source: .resetPassword))
        self.navigationController?.pushViewController(forgetPassword, animated: true)
    }
    
    @objc func loginTapped(){
        guard  email_tf.validate(for: .email) else {return}
        guard password_tf.validate(for: .required(localizedFieldName: "")) else {return}
        viewModel.login(email: email_tf.text, password: password_tf.text,view: self.view)
    }
    
    @objc func createTapped(){
        let createAccount = self.coordinator.Auth.viewcontroller(for: .VerifyEmail(source: .signUp))
        self.navigationController?.pushViewController(createAccount, animated: true)
    }
}
