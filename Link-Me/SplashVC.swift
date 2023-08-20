//
//  SplashVC.swift
//  Link-Me
//
//  Created by Al-attar on 04/07/2023.
//

import UIKit


class SplashVC: UIViewController {
    
    
    var timer: Timer!
    var  coordinator: AppCoordinator!
    var  window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator = AppCoordinator(window:  window!)
       
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(SplashVC.navigate), userInfo: nil, repeats: false)
        
        
    }
    
    @objc func navigate(){
        coordinator.start()
    }
    
   
}
