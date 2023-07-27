//
//  MobileNumberValidator.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

struct MobileNumberValidator: Validatable {

    func validate(_ value: String) throws {
        let number = value
        guard number.count != 0 else {
            throw  ValidationError("RequiredFieldError".localized,
                                   type: .mobileNumber)
        }
        let phoneREGEX = "\\d{9}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneREGEX)
        let result = phoneTest.evaluate(with: value)
        if !result {
            throw ValidationError("invalidMobileNumber".localized,
                                  type: .mobileNumber)
        }
    }

}
