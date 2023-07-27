//
//  CreatePasswordViewController.swift
//  Link-Me
//
//  Created by Al-attar on 15/05/2023.
//

import UIKit

class CreatePasswordViewController: BaseWireFrame<CreatePasswordViewModel>, NavigationBarDelegate {
    
    
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var password_tf: InputView!
    @IBOutlet weak var confirmPassword_tf: InputView!
    @IBOutlet weak var changePassword_btn: MainButton!
    
    //MARK: - Variables
    
    
    
    //MARK: - Bind
    
    override func bind(viewModel: CreatePasswordViewModel) {
        setupView()
        subscriptions()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: ""), and: self)
        changePassword_btn.MainBtn.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)
    }
    
    private func subscriptions(){
        viewModel.forgetPasswordStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                self.navigationController?.popToRootViewController(animated: true)
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    func backButtonPressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func changePasswordTapped(){
        guard password_tf.validate(for: .required(localizedFieldName: "")) else {return}
        guard confirmPassword_tf.validate(for: .confirmPassword(password: password_tf.text)) else {return}
        viewModel.forgetpassword(password: password_tf.text, confirmPassword: confirmPassword_tf.text, view: self.view)
    }
}
