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
        homeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        let vc = UINavigationController(rootViewController: homeVC)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [homeViewContrller].forEach { $0.view.backgroundColor = .setColor(.white) }
        
        viewControllers = [homeViewContrller]
    }
}
