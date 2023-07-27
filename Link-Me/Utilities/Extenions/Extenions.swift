//
//  Extenions.swift
//  DemoAlamofire
//
//  Created by Elattar on 5/18/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import AVFoundation


extension UISearchBar {
    func setTextFieldColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    textField?.backgroundColor = color
                    break
                }
            }
        }
    }
}

extension UIColor{
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    
}


extension UIView{
    
    func anchor(top: NSLayoutYAxisAnchor?,left: NSLayoutXAxisAnchor?,right: NSLayoutXAxisAnchor?,bottom: NSLayoutYAxisAnchor?, paddingTop: CGFloat,paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if  width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if  height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
}


extension UIViewController {
    
    func showAlart(title: String,message: String,okTitle: String = "OK" , okHandler: ((UIAlertAction) -> Void)? = nil){
        
        let alart = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alart.addAction(UIAlertAction(title: okTitle, style: .cancel, handler: okHandler))
        
        self.present(alart, animated: true, completion: nil)
    }
    
    
    
    func setBackbtn(){
        navigationItem.hidesBackButton = true
        
        var backImage = ""
        
        if "lang".localized == "en"{
            backImage = "backBtn"
        }else{
            backImage = "arBack"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: backImage)!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackBtn))
        
    }
    
    @objc func handleBackBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func hideShadowNav(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    

}


extension String{
    var isBlank: Bool{
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}



extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}


class DateFormat{
    static func dateFormat(dateEx: String,dateFormat: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = dateFormat   //"yyyy-MM-dd'T'HH:mm:ss"
        //"yyyy-MM-dd'T'HH:mm:ss.SSS"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM-dd-yyyy"
        
        if let date = dateFormatterGet.date(from: dateEx) {
            //  print(dateFormatterPrint.string(from: date))
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string (Date)")
        }
        return "N/A"
    }
}

public enum ImageFormat {
    case png
    case jpeg(CGFloat)
}

extension UIImage {
    
    public func base64(format: ImageFormat) -> String? {
        var imageData: Data?
        switch format {
        case .png: imageData = self.pngData()
        case .jpeg(let compression): imageData = self.jpegData(compressionQuality: compression)
        }
        return imageData?.base64EncodedString()
    }
}

extension UITextField{
    
    func textfieldStyle(){
        self.layer.borderColor = UIColor.lightGray .cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.tintColor = .gray
    }
    
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIView {
    
    func animate(mainColor: UIColor, subColor:UIColor, duration: CFTimeInterval) {
        let layer = CAGradientLayer()
        let startLocations = [0, 0]
        let endLocations = [1, 2]
        
        layer.colors = [mainColor.cgColor, subColor.cgColor]
        layer.frame = self.bounds
        layer.locations = startLocations as [NSNumber]
        layer.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.layer.addSublayer(layer)
        
        let anim = CABasicAnimation(keyPath: "locations")
        anim.fromValue = startLocations
        anim.toValue = endLocations
        anim.duration = duration
        layer.add(anim, forKey: "loc")
        layer.locations = endLocations as [NSNumber]
    }
}


extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
    func getPixelColor(pos: CGPoint) -> UIColor {

         let pixelData = self.cgImage!.dataProvider!.data
         let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

         let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

         let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
         let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
         let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
         let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

         return UIColor(red: r, green: g, blue: b, alpha: a)
     }

 
}

extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}


extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

//extension String{
//    var localized: String{
//        return NSLocalizedString(self, comment: "")
//    }
//}
