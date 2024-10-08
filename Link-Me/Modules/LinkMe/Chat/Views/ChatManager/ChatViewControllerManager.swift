//
//  ChatViewControllerManager.swift
//  Link-Me
//
//  Created by Al-attar on 04/09/2024.
//

import UIKit

class ActiveViewControllerManager {
    static let shared = ActiveViewControllerManager()
    private init() {}

    var currentViewController: UIViewController?

    func updateCurrentViewController(_ viewController: UIViewController?) {
        currentViewController = viewController
    }
}
