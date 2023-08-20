//
//  AuthNavigator.swift
//  Link-Me
//
//  Created by Breadfast on 05/08/2023.
//

import Foundation
import UIKit

class AuthNavigator: Navigator{
    
    var coordinator: Coordinator
    
    
    enum Destination{
        case login
        case VerifyEmail(source: PhoneVerificationEnum)
        case EnterCode(source: PhoneVerificationEnum, email: String)
        case EmailIsVerified(source: PhoneVerificationEnum,  code: String, email: String)
        case register(code: String, email: String)
        case ProfileNotComplete
        case CreatePassword(code: String,email: String)
    }
    
    required init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    
    func viewcontroller(for destination: Destination) -> UIViewController {
        switch destination{
        case .login:
            let loginRepo = LoginWorker()
            let viewModel = LoginViewModel(login: loginRepo)
            return LoginViewController(viewModel: viewModel, coordinator: coordinator)
        case .VerifyEmail(let source):
            let verifyEmailRepo = VerifyEmailWorker()
            let viewModel = VerifyEmailViewModel(verifyEmail: verifyEmailRepo, source: source)
            return VerifyEmailViewController(viewModel: viewModel, coordinator: coordinator)
        case .EnterCode(let source, let email):
            let verifyCode = VerifyCodeWorker()
            let viewModel = EnterCodeViewModel(source: source, verifyCode: verifyCode, email: email)
            return EnterCodeViewController(viewModel: viewModel, coordinator: coordinator)
        case .EmailIsVerified(let source,let email,let code):
            let viewModel = EmailIsVerifiedViewModel(source: source, code: code, email: email)
            return EmailIsVerifiedViewController(viewModel: viewModel, coordinator: coordinator)
        case .register(let email,let code):
            let registerRepo = RegisterWorker()
            let viewModel = RegisterViewModel(register: registerRepo, email: email, code: code)
            return RegisterViewController(viewModel: viewModel, coordinator: coordinator)
        case .ProfileNotComplete:
            let viewModel = ProfileNotCompleteViewModel()
            return ProfileNotCompleteViewController(viewModel: viewModel, coordinator: coordinator)
        case .CreatePassword(let email,let code):
            let createPassword = ForgetPasswordWorker()
            let viewModel = CreatePasswordViewModel(forgetpassword: createPassword, email: email, code: code)
            return CreatePasswordViewController(viewModel: viewModel, coordinator: coordinator)
        }
    }
}
