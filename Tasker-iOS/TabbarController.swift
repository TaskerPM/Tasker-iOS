//
//  TabbarController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/05.
//

import UIKit

class TabbarController: UITabBarController {
    private let homeViewContrller: UIViewController = {
        let homeVC = HomeViewController()
        let homeTabbarImage = UIImage(named: "tabbar_icon1(select)")
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: homeTabbarImage, tag: 0)
        
        return homeVC
    }()
    
    private let gatherViewController: UIViewController = {
        let gatherVC = GatherViewController()
        let gatherTabbarImage = UIImage(named: "tabbar_icon2(select)")
        gatherVC.tabBarItem = UITabBarItem(title: "모아보기", image: gatherTabbarImage, tag: 1)
        let vc = UINavigationController(rootViewController: gatherVC)
        return vc
    }()
    
    private let browseViewController: UIViewController = {
        let browseVC = BrowseViewController()
        let browseTabbarImage = UIImage(named: "tabbar_icon3(select)")
        browseVC.tabBarItem = UITabBarItem(title: "둘러보기", image: browseTabbarImage, tag: 2)
        let vc = UINavigationController(rootViewController: browseVC)
        return vc
    }()
    
    private let mypageViewController: UIViewController = {
        let mypageVC = GatherViewController()
        let mypageTabbarImage = UIImage(named: "tabbar_icon4(select)")
        mypageVC.tabBarItem = UITabBarItem(title: "마이", image: mypageTabbarImage, tag: 3)
        let vc = UINavigationController(rootViewController: mypageVC)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [homeViewContrller, gatherViewController, browseViewController, mypageViewController]
            .forEach { $0.view.backgroundColor = .setColor(.white) }
        self.tabBar.tintColor = .setColor(.basicBlack)
        self.tabBar.unselectedItemTintColor = .setColor(.gray200)
        
        viewControllers = [homeViewContrller, gatherViewController, browseViewController, mypageViewController]
    }
}
