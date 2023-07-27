//
//  ChangePasswordVC.swift
//  Link-Me
//
//  Created by Al-attar on 25/06/2023.
//

import UIKit

class ChangePasswordVC: BaseWireFrame<ChangePasswordViewModel>, NavigationBarDelegate {

  
    //MARK: - @IBOutlet
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var save_btn: MainButton!
    @IBOutlet weak var correctPassword_TF: InputView!
    @IBOutlet weak var newPassword_TF: InputView!
    @IBOutlet weak var confrimNewPassword_TF: InputView!
    
    //MARK: - Variables
    
    //MARK: - Bind
    
    override func bind(viewModel: ChangePasswordViewModel) {
        setupView()
        subscriptions()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Change Password"), and: self)
        save_btn.MainBtn.addTarget(self, action: #selector(saveChangesTapped), for: .touchUpInside)
    }
    
    private func subscriptions(){
        viewModel.ChangePasswordStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                print("GOOOOOOOO!! 🚀🚀🚀")
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .systemGreen)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Actions
    
    func backButtonPressed() {
         self.navigationController?.popViewController(animated: true)
     }
    
    @objc func saveChangesTapped(){
        
        guard confrimNewPassword_TF.validate(for: .confirmPassword(password: newPassword_TF.text)) else {return}
        
        self.viewModel.changePassword(oldPassword: correctPassword_TF.text, password: newPassword_TF.text, confirmPassword: confrimNewPassword_TF.text, view: self.view)
    }
    
  
}
