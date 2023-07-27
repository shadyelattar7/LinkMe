//
//  UILableEx.swift
//  Link-Me
//
//  Created by Al-attar on 20/05/2023.
//

import Foundation
import UIKit

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UILabel{
    open override func awakeFromNib(){
        super.awakeFromNib()
        setCustomFont()
        
        
//        if !(self.textAlignment == NSTextAlignment.center){
//            if "lang".localized == "en"{
//                textAlignment = .left
//            }else{
//                textAlignment = .right
//            }
//        }
     
    }
    
    func setCustomFont(){
        if let fontDesc = self.font.fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String{
            print(fontDesc)
            let points = font.fontDescriptor.pointSize
            print(points)
            switch fontDesc {
            case "CTFontEmphasizedUsage":
                if "lang".localized == "ar"{
                    font = UIFont(name: ARFont.SemiBold.rawValue, size: points)
                }else{
                    font = UIFont(name: ENFont.SemiBold.rawValue, size: points)
                }
            case "CTFontRegularUsage":
                if "lang".localized == "ar"{
                    font = UIFont(name: ARFont.Regular.rawValue, size: points)
                }else{
                    font = UIFont(name: ENFont.Regular.rawValue, size: points)
                }
            case "CTFontBoldUsage":
                if "lang".localized == "ar"{
                    font = UIFont(name: ARFont.Bold.rawValue, size: points)
                }else{
                    font = UIFont(name: ENFont.Bold.rawValue, size: points)
                }
            case "CTFontLightUsage":
                if "lang".localized == "ar"{
                    font = UIFont(name: ARFont.Light.rawValue, size: points)
                }else{
                    font = UIFont(name: ENFont.Light.rawValue, size: points)
                }
            case "CTFontMediumUsage":
                if "lang".localized == "ar"{
                    font = UIFont(name: ARFont.Medium.rawValue, size: points)
                }else{
                    font = UIFont(name: ENFont.Medium.rawValue, size: points)
                }
            default:
                break
            }
        }
    }
    
    
    @IBInspectable var Translationkey:String {
        get{return ""}
        set{
            self.text = newValue.localized
        }
    }
}


