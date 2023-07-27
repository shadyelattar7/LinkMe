//
//  OnboardingNavigator.swift
//  Link-Me
//
//  Created by Al-attar on 13/05/2023.
//

import Foundation
import UIKit

class OnboardingNavigator: Navigator{
    
    var coordinator: Coordinator
    
  
    enum Destination{
        case onboarding
    }
    
    required init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
  
    
    func viewcontroller(for destination: Destination) -> UIViewController {
        switch destination{
        case .onboarding:
            return OnboardingViewController(viewModel: OnboardingViewModel(), coordinator: coordinator)
        }
    }
}
