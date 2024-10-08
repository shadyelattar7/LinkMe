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
    private var currentPage: Int = 0
      
      func countOnboardingItems() -> Int {
          return onboardingItem.value.count
      }
      
      func getCurrentPage() -> Int {
          return currentPage
      }
      
      func setCurrentPage(_ currentPage: Int) {
          self.currentPage = currentPage
      }
      
      func incrementCurrentPage() {
          if currentPage < countOnboardingItems() - 1 {
              currentPage += 1
          }
      }
      
      func decrementCurrentPage() {
          if currentPage > 0 {
              currentPage -= 1
          }
      }
}
