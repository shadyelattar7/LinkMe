//
//  EnterCodeViewController.swift
//  Link-Me
//
//  Created by Al-attar on 14/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

//1
protocol VerifyEmailData: AnyObject {
    func VerifyEmailData(isVerifyEmail: Bool, otp: String)
}

class EnterCodeViewController: BaseWireFrame<EnterCodeViewModel>, NavigationBarDelegate {
    
    
    //MARK: - @IBOutlet
    
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var subtitle_lbl: UILabel!
    @IBOutlet private weak var verificationCode: UITextField!
    @IBOutlet var codeDigits: [UILabel]!
    @IBOutlet private weak var resendCodeBtn: UIButton!
    @IBOutlet weak var wrongCode_lbl: UILabel!
    @IBOutlet weak var verifyEmail_btn: MainButton!
    @IBOutlet weak var title_lbl: UILabel!
    
    //MARK: - Variables
    
    private var timer = Timer()
    private var count = 120
    private var resentStr = "resend"
    //2
    weak var delegate: VerifyEmailData!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupResendCodeTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }
    
    //MARK: - Bind
    
    override func bind(viewModel: EnterCodeViewModel) {
        setupView()
        subscriptions()
    }
    
    //MARK: - Private func
    
    private func setupView(){
        self.navBar.configure(with: NavigationBarViewModel(navBarTitle: ""), and: self)
        
        verificationCode.inputAccessoryView = UIView()
        verificationCode.becomeFirstResponder()
        verificationCode.keyboardType = .asciiCapableNumberPad
        
        verifyEmail_btn.MainBtn.addTarget(self, action: #selector(VerifyCode), for: .touchUpInside)
        wrongCode_lbl.isHidden = true
        
        for item in codeDigits.enumerated(){
            item.element.cornerRadius = 12
        }
    }
    
    private func subscriptions(){
        viewModel.verifyCodeStatus.subscribe { [weak self] model in
            guard let self = self, let model = model.element else {return}
            if model.status ?? false{
                if self.viewModel.source == .changeEmail{
                    self.navigationController?.popViewControllerWithHandler {
                        self.delegate.VerifyEmailData(isVerifyEmail: true, otp: self.verificationCode.text!)
                    }
                }else{
                    let emailIsVerified = self.coordinator.Auth.viewcontroller(for: .EmailIsVerified(source: self.viewModel.source, code: self.verificationCode.text! ,email: self.viewModel.email ?? ""))
                    self.navigationController?.pushViewController(emailIsVerified, animated: true)
                }
            }else{
                ToastManager.shared.showToast(message: model.message ?? "", view: self.view, postion: .top, backgroundColor: .LinkMeUIColor.errorColor)
            }
        }.disposed(by: disposeBag)
    }
    
    // Timer Setup
    private func setupResendCodeTimer(){
        count = 120
        resendCodeBtn.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        if count > 0 {
            count-=1
            resendCodeBtn.setTitle("\(count/60):\(count%60)", for: .normal)
        } else if count == 0 {
            timer.invalidate()
            resendCodeBtn.setTitle(resentStr.localized, for: .normal)
            resendCodeBtn.isUserInteractionEnabled = true
        }
    }
    
    private func validateDigits() -> Bool {
        
        if verificationCode.text?.isBlank == true || verificationCode.text?.count != 4{
            for item in codeDigits.enumerated(){
                item.element.layer.borderWidth = 1
                item.element.layer.borderColor = UIColor.LinkMeUIColor.errorColor.cgColor
            }
            return false
        }else{
            return true
        }
        
        
    }
    
    //MARK: - Actions
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func VerifyCode(){
        if validateDigits(){
            print("pass")
            viewModel.VerifyCode(Code: verificationCode.text!,view: self.view)
        }
    }
    
    
    @IBAction func typingVerifactionCode(_ sender: UITextField) {
        if sender.text?.count ?? 0 > 4{
            sender.deleteBackward()
        }else{
            let codeDigitsArr: [String] = sender.text!.map{ String($0) }
            for item in codeDigits.enumerated(){
                if item.offset < codeDigitsArr.count{
                    item.element.text = codeDigitsArr[item.offset]
                    item.element.layer.borderWidth = 0
                    item.element.textColor = UIColor.black
                }else{
                    item.element.text = "-"
                    item.element.textColor = UIColor.LinkMeUIColor.strongGray
                }
            }
        }
        
        
        if sender.text?.count == 4{
            //TODO: - check the code
            //            switch source!{
            //            case .signUp(let vm, _):
            //                vm.verifyOTP(otp: sender.text!)
            //                break
            //                
            //            case .resetPassword(let vm, _):
            //                vm.verifyResetPasswordOTP(otp: sender.text!)
            //                break
            //            }
        }
    }
}
