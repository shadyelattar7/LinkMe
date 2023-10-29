//
//  TabBarController.swift
//  Link-Me
//
//  Created by Al-attar on 10/05/2023.
//

import UIKit

class TabBarController: UITabBarController {

    let coordinator: Coordinator!
    var window: UIWindow?

    
    init(coordinator: Coordinator){
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        UDHelper.isAfterLoginOrRegister = false
        if UDHelper.isCompleteProfile{
            self.selectedIndex = 3
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum TabBarItem:Int, CaseIterable{
        case LinkMe
        case Stories
        case Message
        case Profile
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        setupTabBarUI()
    }

    private func setupTabBarUI(){
        tabBar.tintColor = UIColor.LinkMeUIColor.mainColor
        tabBar.unselectedItemTintColor = .none
    }

    private func setupTabBarItems(){
        self.viewControllers =  TabBarItem.allCases.map({
            let view = viewControllerForTabBarItem($0)
            let navgtion = UINavigationController(rootViewController: view)
            return navgtion
        })
    }
    
    func viewControllerForTabBarItem(_ item: TabBarItem) -> UIViewController{
        switch item{
        case .LinkMe:
            let view = coordinator.Main.viewcontroller(for: .LinkMe )
            view.tabBarItem = tabBarItem(for: item)
            return view
        case .Stories:
            let view = coordinator.Main.viewcontroller(for: .MainStory)
            view.tabBarItem = tabBarItem(for: item)
            return view
        case .Message:
            let view = LinkMeViewController(viewModel: LinkMeViewModel(), coordinator: coordinator)
            view.tabBarItem = tabBarItem(for: item)
            return view
        case .Profile:
            let view = coordinator.Main.viewcontroller(for: .Profile)
            view.tabBarItem = tabBarItem(for: item)
            return view
        }
    }
    
    private func tabBarItem(for item: TabBarItem) -> UITabBarItem?{
        let tabBarItem: UITabBarItem
        switch item{
        case .LinkMe:
            tabBarItem = .init(title: "Link Me".localized, image: #imageLiteral(resourceName: "UnselectLinkMe"), selectedImage: #imageLiteral(resourceName: "UnselectLinkMe"))
        case .Stories:
            tabBarItem = .init(title: "Stories".localized, image: #imageLiteral(resourceName: "UnselectStory"), selectedImage: #imageLiteral(resourceName: "UnselectStory"))
        case .Message:
            tabBarItem = .init(title: "Message".localized, image: #imageLiteral(resourceName: "UnselectChat"), selectedImage: #imageLiteral(resourceName: "UnselectChat"))
        case .Profile:
            tabBarItem = .init(title: "Profile".localized, image: #imageLiteral(resourceName: "UnselectProfile"), selectedImage: #imageLiteral(resourceName: "UnselectProfile"))
        }
        return tabBarItem
    }

}
