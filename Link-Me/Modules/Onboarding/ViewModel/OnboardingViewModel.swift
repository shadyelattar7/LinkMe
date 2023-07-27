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
        onboardingitems.init(image: UIImage(named: "Group 62704"), title: "Title Here", subTitle: "Lorem ipsum dolor sit amet consetetur sadipscing elitr sed diam nonumy",stepImg: UIImage(named: "step1")),
        onboardingitems.init(image: UIImage(named: "Group 62703"), title: "Title Here", subTitle: "Lorem ipsum dolor sit amet consetetur sadipscing elitr sed diam nonumy",stepImg: UIImage(named: "step2")),
        onboardingitems.init(image: UIImage(named: "Group 62700"), title: "Title Here", subTitle: "Lorem ipsum dolor sit amet consetetur sadipscing elitr sed diam nonumy",stepImg: UIImage(named: "step3"))
    ])
    
    
    func countOnboardingItems() -> Int{
        onboardingItem.value.count
    }
    
}
