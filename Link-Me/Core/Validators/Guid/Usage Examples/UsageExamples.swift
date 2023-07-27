//
//  ValidatorUsageExample.swift
//  POMacArch
//
//  Created by Al-attar on 05/05/2021.
//  Copyright © 2021 POMac. All rights reserved.
//

import Foundation

func validateThatThrowError() {
    do {
        try "Gemy@h.net".validate(for: .email)
        try "22".validate(for: .age)
        try "Required field".validate(for: .required(localizedFieldName: "THE NAME OF this FIELD"))
        // you have to pass the name of the field to appear in the error message "$fieldName is missing"
    } catch let error {
     let errorParsed = error as! ValidationError
        print(errorParsed.message)
    }
}

func isValid() {
    if "22".isValid(type: .age) {
        print("valid")
    }
}
