//
//  Helper.swift
//  Link-Me
//
//  Created by Al-attar on 13/05/2023.
//

import Foundation
import UIKit

class UDHelper {
    
    private static let userDefaults = UserDefaults.standard
    
    static var isAppOpenedBefor: Bool {
        set { UDHelper.userDefaults.set(newValue, forKey: UDKeys.appOpenedBrfore) }
        get { UDHelper.userDefaults.bool(forKey: UDKeys.appOpenedBrfore) }
    }
    
    static var token: String {
        set {UDHelper.userDefaults.set(newValue, forKey: UDKeys.token)}
        get { UDHelper.userDefaults.string(forKey: UDKeys.token) ?? "" }
        
    }
    
    static var isAfterLoginOrRegister: Bool{
        set { UDHelper.userDefaults.set(newValue, forKey: UDKeys.isLoginOrRegister) }
        get { UDHelper.userDefaults.bool(forKey: UDKeys.isLoginOrRegister) }
    }
    
   
    
    static var isSkip: Bool{
        set { UDHelper.userDefaults.set(newValue, forKey: UDKeys.isSkip) }
        get { UDHelper.userDefaults.bool(forKey: UDKeys.isSkip) }
    }
    
    static var isChangeLang: Bool{
        set { UDHelper.userDefaults.set(newValue, forKey: UDKeys.isChangeLang) }
        get { UDHelper.userDefaults.bool(forKey: UDKeys.isChangeLang) }
    }
    
    static var isCompleteProfile: Bool{
        set { UDHelper.userDefaults.set(newValue, forKey: UDKeys.isCompleteProfile) }
        get { UDHelper.userDefaults.bool(forKey: UDKeys.isCompleteProfile) }
    }
    
    static var isDrag: Bool{
        set { UDHelper.userDefaults.set(newValue, forKey: UDKeys.isDrag) }
        get { UDHelper.userDefaults.bool(forKey: UDKeys.isDrag) }
    }
    
    static var isVistor: Bool{
        set { UDHelper.userDefaults.set(newValue, forKey: UDKeys.isVistor) }
        get { UDHelper.userDefaults.bool(forKey: UDKeys.isVistor) }
    }

    static var isVistorLoggedIn: Bool{
        set { UDHelper.userDefaults.set(newValue, forKey: UDKeys.isVistorLoggedIn) }
        get { UDHelper.userDefaults.bool(forKey: UDKeys.isVistorLoggedIn) }
    }
    
    static func saveUserData(obj: User?){
        do{
            try UserDefaults.standard.setObject(obj, forKey: UDKeys.userData)
        }catch{
            print("Error to save obj")
        }
    }
    
    static var fetchUserData : User? {
        do{
            let userModel = try UserDefaults.standard.getObject(forKey: UDKeys.userData, castTo: User.self)
            return userModel
        }catch{
            print("Error to fetch obj")
        }
        return nil
    }
    
}
