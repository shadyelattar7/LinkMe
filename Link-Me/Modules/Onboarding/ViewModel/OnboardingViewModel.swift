//
//  OnboardingViewModel.swift
//  Link-Me
//
//  Created by Al-attar on 12/05/2023.
//

import Foundation
import RxCocoa
import RxSwift

struct onboardingitems{
    var image: UIImage!
    var title: String!
    var subTitle: String!
    var stepImg: UIImage!
}

class OnboardingViewModel: BaseViewModel{
    
    var onboardingItem: BehaviorRelay<[onboardingitems]> = .init(value: [
        onboardingitems.init(image: UIImage(named: "Group1"), title: "Hello!".localized, subTitle: "Hello! Welcome to the Link Me app! Discover new worlds of social interaction with just one tap.".localized,stepImg: UIImage(named: "step1")),
        onboardingitems.init(image: UIImage(named: "Group2"), title: "New World".localized, subTitle: "Welcome to the new world of social networking! Let Link Me guide you to unforgettable friendships and interactions.".localized,stepImg: UIImage(named: "step2")),
        onboardingitems.init(image: UIImage(named: "Group3"), title: "a unique way".localized, subTitle: "We’re excited to see you here! Enjoy your journey in the Link Me app, where randomness meets social networking in a unique way.".localized,stepImg: UIImage(named: "step3"))
    ])
    
    
    func countOnboardingItems() -> Int{
        onboardingItem.value.count
    }
    
}
