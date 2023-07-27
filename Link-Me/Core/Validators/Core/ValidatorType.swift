//
//  ValidatorType.swift
//  Link-Me
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

public enum ValidatorType {
    case email
    case required(localizedFieldName: String)
    case age
    case password
    case confirmPassword(password: String)
    case confirmEmail(_ email: String)
    case mobileNumber
    case characterCount(_ count: Int)
}
