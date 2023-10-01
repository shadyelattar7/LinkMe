//
//  AppDelegate.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import UIKit
import IQKeyboardManagerSwift
import MOLH

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable{
  
   // var  coordinator: AppCoordinator!
    var  window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        coordinator = AppCoordinator(window: window!)
//        coordinator.start()
        
        LocalizationManager.shared.delegate = self
        LocalizationManager.shared.setAppInnitLangauge()
        
        MOLH.shared.activate(true)
        setupIQKeyboardManager()
        
        print("Token 🔒: \(UDHelper.token)")
      
        return true
    }
    
    private func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false

    }
    
    func reset() {
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = redViewController
        let rootViewController: UIWindow = ((UIApplication.shared.delegate?.window)!)!
        let stry = UIStoryboard(name: "Main", bundle: nil)
        rootViewController.rootViewController = stry.instantiateViewController(withIdentifier: "SplashVC")
  
    }
    
}


extension AppDelegate: LocalizationDelegate{
    func resetApp() {
        guard let window = window else {return}
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        vc.window = window
        window.rootViewController = vc
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval  = 0.3
        UIView.transition(with: window, duration: duration,options: options, animations: nil)
    }
}
