//
//  EmailValidator.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

struct EmailValidator: Validatable {

    func validate(_ value: String) throws {
        if value.isEmpty {
            throw ValidationError("RequiredFieldError".localized,
                                  type: .email)
        }

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: value)
        if !result {
            throw ValidationError("Email Invalid".localized,
                                  type: .email)
        }
    }
}
