//
//  Navigator.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import Foundation
import UIKit

enum NavigtorTypes{
    case push
    case present(style: UIModalPresentationStyle = .automatic)
    case root
    case presentNavgation
    
}
protocol Navigator{
    associatedtype Destination
    func viewcontroller(for destination: Destination ) -> UIViewController
    init(coordinator: Coordinator)
    var coordinator: Coordinator {get}
    func navigate(for destination: Destination, navigtorTypes: NavigtorTypes )
}


extension Navigator{
    func navigate(for destination: Destination, navigtorTypes: NavigtorTypes = .push ){
        let viewController = self.viewcontroller(for: destination)
        switch navigtorTypes{
        case .push:
            coordinator.navgationController?.pushViewController(viewController, animated: true)
        case .present(let style):
            viewController.modalPresentationStyle = style
            coordinator.navgationController?.present(viewController, animated: true)
        case .root:
            coordinator.navgationController?.setViewControllers([viewController], animated: true)
        case .presentNavgation:
            let nav = UINavigationController(rootViewController: viewController)
            coordinator.navgationController?.present(nav, animated: true, completion: nil)
        }
    }

}
