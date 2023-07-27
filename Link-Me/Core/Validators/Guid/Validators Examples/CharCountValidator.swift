//
//  CountValidator.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

struct CharCountValidator: Validatable {

    private let charCount: Int

    init(charCount: Int) {
        self.charCount = charCount
    }

    func validate(_ value: String) throws {
        guard value.count == charCount else {
            throw ValidationError(
                "Your string must be atleast \(charCount) long",
                type: .characterCount(charCount))
        }
    }

}
