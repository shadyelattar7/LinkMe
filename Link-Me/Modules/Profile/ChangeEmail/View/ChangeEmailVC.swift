//
//  ChangeEmailVC.swift
//  Link-Me
//
//  Created by Al-attar on 25/06/2023.
//

import UIKit
import RxSwift
import RxCocoa


class ChangeEmailVC: BaseWireFrame<ChangeEmailViewModel>, NavigationBarDelegate{
    
    
    //MARK: - @IBOutlet -
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var save_btn: MainButton!
    @IBOutlet weak var email_TF: InputView!
    @IBOutlet weak var newEmail_TF: InputView!
    @IBOutlet weak var confirmNewEmail_TF: InputView!
    
    var isEmailVerfied: Bool = false
    var code: String = ""
    
    //MARK: - Bind -
    
    override func bind(viewModel: ChangeEmailViewModel) {
        setupView()
        subscriptions()
    }
    
    
    //MARK: - Private func -
    
    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Change Email"), and: self)
        save_btn.MainBtn.addTarget(self, action: #selector(saveChangesTapped), for: .touchUpInside)
        email_TF.text = UDHelper.fetchUserData?.email ?? ""
    }
    
    private func subscriptions(){
        
    
        viewModel.VerifyEmailStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                let EnterCodeVC = self.coordinator.Auth.viewcontroller(for: .EnterCode(source: .changeEmail, email: self.newEmail_TF.text)) as! EnterCodeViewController
                EnterCodeVC.delegate = self
                self.navigationController?.pushViewController(EnterCodeVC, animated: true)
               // self.coordinator.Auth.navigate(for: .EnterCode(source: .changeEmail, email: self.newEmail_TF.text))
            }else{
                print("Model: \(model)")
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
            
            
        }.disposed(by: disposeBag)
        
        viewModel.ConfirmUpdateEmailStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .systemGreen)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else{
                print("Model: \(model)")
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
            
            
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Actions -
    
    func backButtonPressed() {
         self.navigationController?.popViewController(animated: true)
     }
    
    @objc func saveChangesTapped(){
        guard email_TF.validate(for: .email),
              newEmail_TF.validate(for: .email),
              confirmNewEmail_TF.validate(for: .email)
        else {return}

        

        if isEmailVerfied{
            viewModel.confirmUpdateEmail(email: newEmail_TF.text, code: code, view: self.view)
        }else{
            viewModel.changeEmail(email: newEmail_TF.text, view: self.view)
        }
    }
}

//MARK: - Confirm Protocol

extension ChangeEmailVC: VerifyEmailData{
    func VerifyEmailData(isVerifyEmail: Bool, otp: String) {
        print("isVerifyEmail: \(isVerifyEmail), otp: \(otp)")
        self.isEmailVerfied = isVerifyEmail
        self.code = otp
    }
    
}
