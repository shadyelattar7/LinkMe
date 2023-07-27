//
//  Validatable.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

protocol Validatable {
    func validate(_ value: String) throws
    func isValid(_ value: String) -> Bool

}
extension Validatable {
    func isValid(_ value: String) -> Bool {
        do {
            try  validate( value)
            return true
        } catch {
            return false}
    }
}
