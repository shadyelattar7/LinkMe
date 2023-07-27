//
//  AgeValidator.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

struct AgeValidator: Validatable {
    func validate(_ value: String) throws {
        guard value.count > 0 else {throw ValidationError("AgeMissingError".localized, type: .age)}
        guard Int(value) != nil else {throw ValidationError("AgeNotNumber".localized, type: .age)}
        guard value.count < 3 else {throw ValidationError("AgeIsNotValidError".localized, type: .age)}
    }
}
