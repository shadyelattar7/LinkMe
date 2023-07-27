//
//  RequiredFieldValidator.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation
struct RequiredFieldValidator: Validatable {

    init() { }

    func validate(_ value: String) throws {
        guard !value.isEmpty else {
            throw  ValidationError("RequiredFieldError".localized,
                                   type: .required(localizedFieldName: ""))
        }
    }

}
