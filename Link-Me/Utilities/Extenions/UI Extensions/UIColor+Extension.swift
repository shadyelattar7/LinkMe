//
//  UIColor+Extension.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import UIKit

extension UIColor {
    public enum LinkMeUIColor {
        static let mainColor = UIColor.rgb(red: 118, green: 78, blue: 232)
        static let lightPurple = UIColor.rgb(red: 232, green: 225, blue: 255)
        static let errorColor = UIColor.rgb(red: 255, green: 48, blue: 151)
        static let lightPink = UIColor.rgb(red: 255, green: 225, blue: 255)
        static let successColor = UIColor.rgb(red: 30, green: 213, blue: 151)
        static let lightGray = UIColor.rgb(red: 249, green: 249, blue: 249)
        static let strongGray = UIColor.rgb(red: 95, green: 108, blue: 123)
        static let strongGreen = UIColor.rgb(red: 28, green: 180, blue: 159)
        static let strongPink = UIColor.rgb(red: 255, green: 35, blue: 130)
        static let strongPurple = UIColor.rgb(red: 88, green: 75, blue: 125)
        static let lightYellow = UIColor.rgb(red: 255, green: 247, blue: 226)
        static let strongYellow = UIColor.rgb(red: 232, green: 171, blue: 7)
        static let darkBlue = UIColor.rgb(red: 9, green: 64, blue: 103)
        static let strongOrang = UIColor.rgb(red: 255, green: 171, blue: 25)
        static let lightOrang = UIColor.rgb(red: 255, green: 229, blue: 203)
        static let strongRepliedGreen = UIColor.rgb(red: 29, green: 190, blue: 17)
        static let lightRepliedGreen = UIColor.rgb(red: 203, green: 255, blue: 231)
    }
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
