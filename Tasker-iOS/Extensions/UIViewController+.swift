//
//  UIViewController+.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/06/08.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(_ child: UIViewController) {
        guard parent != nil else { return }
        
        willMove(toParent: child)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
