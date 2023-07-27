//
//  UITextViewEx.swift
//  Link-Me
//
//  Created by Al-attar on 10/07/2023.
//

import Foundation
import UIKit

extension UITextView {
    open override func awakeFromNib(){
        super.awakeFromNib()
        if !(self.textAlignment == NSTextAlignment.center){
            if "lang".localized == "en"{
                textAlignment = .left
            }else{
                textAlignment = .right
            }
        }
    }
}
