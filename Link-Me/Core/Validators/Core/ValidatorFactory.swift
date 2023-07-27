//
//  ValidatorFactory.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

struct ValidatorResolver {
    static func validate(for type: ValidatorType) -> Validatable {
        switch type {
        case .email: return EmailValidator()
        case .required: return RequiredFieldValidator()
        case .age: return AgeValidator()
        case .password: return PasswordValidator()
        case .confirmPassword(let password) : return ConfirmPasswordValidator(password: password)
        case .confirmEmail(let email): return ConfirmEmailValidator(email: email)
        case .mobileNumber: return MobileNumberValidator()
        case .characterCount(let count): return CharCountValidator(charCount: count)
        }
    }
}
