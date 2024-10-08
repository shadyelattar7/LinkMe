//
//  AppCoordinator.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import UIKit

protocol Coordinator{
    var Onboarding: OnboardingNavigator {get}
    var Auth: AuthNavigator {get}
    var Main: MainNavigator {get}
    var navgationController: UINavigationController? {get}
    func start()
    func switchToTabBar()
    func presentLogin(viewController: UIViewController)
}

class AppCoordinator: Coordinator{
    
    var window: UIWindow
    
    lazy private var tabbar: TabBarController = {
        return TabBarController(coordinator: self)
    }()
    
    //    lazy private var login: LoginViewController = {
    //        return LoginViewController(viewModel: LoginViewModel(), coordinator: self)
    //    }()
    
    lazy var Onboarding: OnboardingNavigator = {
        return .init(coordinator: self)
    }()
    
    lazy var Auth: AuthNavigator = {
        return .init(coordinator: self)
    }()
    
    lazy var Main: MainNavigator = {
        return .init(coordinator: self)
    }()
    
    var navgationController: UINavigationController?{
        if let navgationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController{
            return navgationController
        }else  if let navgationController = tabbar.selectedViewController as? UINavigationController{
            return navgationController
        }else{
            print("Error to navgation in app coordinator")
            return nil
        }
        
    }
    
    init(window: UIWindow = UIWindow()){
        self.window = window
    }
    
    func presentLogin(viewController: UIViewController) {
        let loginVC = self.Auth.viewcontroller(for: .login)
        let nav = UINavigationController(rootViewController: loginVC)
        viewController.present(nav, animated: true)
    }
    
    func switchToTabBar(){
        let vc = TabBarController(coordinator: self)
        vc.window = window
        window.rootViewController = vc
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval  = 0.3
        UIView.transition(with: window, duration: duration,options: options, animations: nil)
    }
    
    func start(){
        if UDHelper.isAfterLoginOrRegister == true  {
            window.rootViewController = rootViewController
            // window.makeKeyAndVisible()
            UIView.transition(with: self.window, duration: 1.0, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }else{
            window.rootViewController = rootViewController
            window.makeKeyAndVisible()
        }
    }
    var rootViewController: UIViewController{
        if UDHelper.isAppOpenedBefor{
            if UDHelper.token != "" || UDHelper.isSkip == true || UDHelper.isCompleteProfile == true  {
                return tabbar
            }else{
                let loginVC = self.Auth.viewcontroller(for: .login)
                let nav = UINavigationController(rootViewController: loginVC)
                return nav
            }
        }else{ // open onboarding
            let onboadingVC = self.Onboarding.viewcontroller(for: .onboarding)
            let nav = UINavigationController(rootViewController: onboadingVC)
            return nav
        }
    }
}

