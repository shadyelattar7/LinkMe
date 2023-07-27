//
//  ValidationError.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

class ValidationError: Error {

    let type: ValidatorType
    let message: String

    init(_ message: String, type: ValidatorType) {
        self.message = message
        self.type = type
    }
}
