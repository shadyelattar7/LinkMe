//
//  UIImageEx.swift
//  Link-Me
//
//  Created by Al-attar on 26/06/2023.
//

import Foundation
import UIKit

extension UIImageView {
    
    open override func awakeFromNib(){
        super.awakeFromNib()
      //  flipImage()
    }
    
    func flipImage(){
        if "lang".localized == "ar" {
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        
    }
}


