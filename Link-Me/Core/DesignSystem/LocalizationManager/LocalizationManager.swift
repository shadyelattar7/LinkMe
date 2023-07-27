//
//  LocalizationManager.swift
//  DemoLocalization
//
//  Created by Al-attar on 20/03/2023.
//

import Foundation
import UIKit

protocol LocalizationDelegate: AnyObject{
    func resetApp()
}

class LocalizationManager: NSObject{
    enum LanguageDirection{
        case leftToRight
        case rightToLeft
    }
    
    enum Language: String{
        case English = "en"
        case Arabic = "ar"
        
    }
    
    static let shared = LocalizationManager()
    private var bundle: Bundle? = nil
    private var languageKey = "UKPrefLang"
    weak var delegate: LocalizationDelegate?
    
    //MARK: - Get currently selected language from el user defaults
    func getLangauage() -> Language?{
        if let languageCode = UserDefaults.standard.string(forKey: languageKey), let language = Language(rawValue: languageCode){
            return language
        }
        return nil
    }
    
    //MARK: - Check if the languge is available
    private func isLanguageAvailable(_ code: String) -> Language?{
        var finaCode = ""
        if code.contains("ar"){
            finaCode = "ar"
        }else if code.contains("en"){
            finaCode = "en"
        }
        return Language(rawValue: finaCode)
    }
    
    //MARK: - Check the language direction
    private func getLanguageDirection() -> LanguageDirection{
        if let lang = getLangauage(){
            switch lang{
            case .English:
                return .leftToRight
            case .Arabic:
                return .rightToLeft
            }
        }
        return .leftToRight
    }
    
    //MARK: - Get localized string for a given code from the active bundle
    func localizedString(for key: String, value comment: String) -> String{
        let localized = bundle!.localizedString(forKey: key, value: comment, table: nil)
        return localized
    }
    
    //MARK: - Set language for localization
    func setLanguage(language: Language){
        UserDefaults.standard.set(language.rawValue, forKey: languageKey)
        if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"){
            bundle = Bundle(path: path)
        }else{
            //fallback
            resetLocalization()
        }
        
        UserDefaults.standard.synchronize()
        resetApp()
    
        
    }
    
    func resetLocalization(){
        bundle = Bundle.main
    }
    
    //MARK: - Reset App
    func resetApp(){
        let dir = getLanguageDirection()
        var semantic: UISemanticContentAttribute!
        switch dir{
        case .leftToRight:
            semantic = .forceLeftToRight
        case .rightToLeft:
            semantic = .forceRightToLeft
        }
        
        UIView.appearance().semanticContentAttribute = semantic
        UIButton.appearance().semanticContentAttribute = semantic
        UITextView.appearance().semanticContentAttribute = semantic
        UITextField.appearance().semanticContentAttribute = semantic
        UINavigationBar.appearance().semanticContentAttribute = semantic
        UITabBar.appearance().semanticContentAttribute = semantic
        UISearchBar.appearance().semanticContentAttribute = semantic
        UILabel.appearance().semanticContentAttribute = semantic
        UIImageView.appearance().semanticContentAttribute = semantic
        UIStackView.appearance().semanticContentAttribute = semantic
        UITableView.appearance().semanticContentAttribute = semantic
        UISwitch.appearance().semanticContentAttribute = .forceLeftToRight
        
        delegate?.resetApp()
      
    }
    
    //MARK: - Configure startup language
    func setAppInnitLangauge(){
        if let selectedLanguage = getLangauage(){
            setLanguage(language: selectedLanguage)
        }else{
            //no language was selected
            let languageCode = Locale.preferredLanguages.first
            if let code = languageCode, let language = isLanguageAvailable(code){
                setLanguage(language: language)
            }else{
                //defualt fall back
                setLanguage(language: .English)
            }
        }
        resetApp()
    }
}


extension String{
    var localized: String{
        return LocalizationManager.shared.localizedString(for: self, value: "")
    }
}
