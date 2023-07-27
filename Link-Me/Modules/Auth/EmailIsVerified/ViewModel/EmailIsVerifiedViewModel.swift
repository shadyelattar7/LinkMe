//
//  EmailIsVerifiedViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 16/05/2023.
//

import Foundation

class EmailIsVerifiedViewModel: BaseViewModel{
    
    var source: PhoneVerificationEnum!
    var email: String?
    var code: String?
    
    init(source: PhoneVerificationEnum, code: String,email: String ) {
        self.source = source
        self.code = code
        self.email = email
    }
}
