//
//  mainButton.swift
//  Link-Me
//
//  Created by Al-attar on 6/2/21.
//

import UIKit

protocol MainButtonTapped {
    func buttonTapped()
}
class MainButton: NibLoadingView {
    
    @IBOutlet weak var MainBtn: UIButton!
    var buttonTappedDeleget : MainButtonTapped?
    
    @IBInspectable var textTitle: String {
        get {
            self.textTitle
        }
        set {
            MainBtn.setTitle(newValue, for: .normal)
        }
    }
    
    @IBInspectable var isBoarder: Bool = false {
        didSet {
            if isBoarder {
                MainBtn.backgroundColor = .white
                MainBtn.setTitleColor(.LinkMeUIColor.mainColor, for: .normal)
                MainBtn.layer.cornerRadius = 12
                MainBtn.layer.borderWidth = 2
                MainBtn.layer.borderColor = UIColor.LinkMeUIColor.mainColor.cgColor
            }else{
                MainBtn.layer.cornerRadius = 12
            }
        }
    }
    
    
    @IBInspectable var Translationkey:String {
        get{return ""}
        set{
            self.MainBtn.setTitle(newValue.localized, for: .normal)
        }
    }
    
    
    @IBAction func mainButton(_ sender: Any) {
        buttonTappedDeleget?.buttonTapped()
    }
    
}
