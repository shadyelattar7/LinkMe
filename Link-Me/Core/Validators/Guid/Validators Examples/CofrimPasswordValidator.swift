//
//  confirmPasswordValidator.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation
struct ConfirmPasswordValidator: Validatable {

    let password: String
    init(password: String) {
        self.password = password
    }
    func validate(_ value: String) throws {
        guard value.count != 0 else {
            throw  ValidationError("RequiredFieldError".localized,
                                   type: .confirmPassword(password: password))
        }
        guard password == value  else {
            throw  ValidationError("confirmPasswordInvalid".localized,
                                   type: .confirmPassword(password: password))
        }
    }

}
