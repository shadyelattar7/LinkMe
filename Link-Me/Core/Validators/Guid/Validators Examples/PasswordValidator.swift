//
//  PasswordValidator.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

struct PasswordValidator: Validatable {

    func validate(_ value: String) throws {
        if value.isEmpty {
            throw ValidationError("RequiredFieldError".localized,
                                  type: .password)
        }
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%\\-*?&])[A-Za-z\\d\\-$@$!%*?&.]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        let result = passwordTest.evaluate(with: value)
        if !result {
            throw ValidationError("PasswordInvalid".localized,
                                  type: .password)
        }
    }
}
