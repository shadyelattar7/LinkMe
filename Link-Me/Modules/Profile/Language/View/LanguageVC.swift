//
//  LanguageVC.swift
//  Link-Me
//
//  Created by Al-attar on 26/06/2023.
//

import UIKit
import MOLH

class LanguageVC: BaseWireFrame<LanguageViewModel>, NavigationBarDelegate {

    //MARK: - @IBOutlet
    @IBOutlet weak var navBar: NavigationBarView!
    @IBOutlet weak var engIcon_iv: UIImageView!
    @IBOutlet weak var arIcon_iv: UIImageView!
    
    //MARK: - Bind
    
    override func bind(viewModel: LanguageViewModel) {
        setupView()
    }

    private func setupView(){
        navBar.configure(with: NavigationBarViewModel(navBarTitle: "Language".localized), and: self)
        
        if "lang".localized == "en"{
            engIcon_iv.image = UIImage(named: "tick-circle 2")
            arIcon_iv.image = UIImage(named: "tick-circle 1")
        }else{
            engIcon_iv.image = UIImage(named: "tick-circle 1")
            arIcon_iv.image = UIImage(named: "tick-circle 2")
        }
        
        
    }

    @IBAction func engTapped(_ sender: Any) {
        engIcon_iv.image = UIImage(named: "tick-circle 2")
        arIcon_iv.image = UIImage(named: "tick-circle 1")
        UDHelper.isChangeLang = true
//        MOLH.setLanguageTo("en")
//        MOLH.reset()
        
        LocalizationManager.shared.setLanguage(language: .English)
        
        
    }
    
    @IBAction func arbTapped(_ sender: Any) {
        engIcon_iv.image = UIImage(named: "tick-circle 1")
        arIcon_iv.image = UIImage(named: "tick-circle 2")
        UDHelper.isChangeLang = true
//        MOLH.setLanguageTo("ar")
//        MOLH.reset()
        
        LocalizationManager.shared.setLanguage(language: .Arabic)
    }
    
    func backButtonPressed() {
         self.navigationController?.popViewController(animated: true)
     }
}
