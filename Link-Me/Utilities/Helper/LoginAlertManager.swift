//
//  LoginAlertManager.swift
//  Link-Me
//
//  Created by Al-attar on 10/11/2023.
//

import UIKit


class QuickAlert {
    static func showWith(in viewConroller: UIViewController, coordentor: Coordinator) {
        let alertVC = UIAlertController(title: nil, message: "You have to log in to use this feature.", preferredStyle: .alert)
        let signInAction: UIAlertAction = .init(title: "Login", style: .default) { (ـ) in
            coordentor.Auth.navigate(for: .login, navigtorTypes: .presentNavgation)
        }
        
        let cancelAction: UIAlertAction = .init(title: "Cancel", style: .cancel)
        alertVC.addAction(signInAction)
        alertVC.addAction(cancelAction)
        viewConroller.present(alertVC, animated: true)
    }
}
