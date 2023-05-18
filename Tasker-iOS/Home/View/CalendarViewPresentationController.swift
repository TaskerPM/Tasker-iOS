//
//  CalendarViewPresentationController.swift
//  Tasker-iOS
//
//  Created by mingmac on 2023/05/18.
//

import UIKit

class CalendarViewPresentationController: UIPresentationController {
    private let backgroundView: UIView

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView else { return CGRect() }
        
        if containerView.frame.height >= 812 {
            return CGRect(x: 0, y: containerView.frame.height * 0.46, width: containerView.frame.width, height: containerView.frame.height * 0.54)
        } else {
            return CGRect(x: 0, y: containerView.frame.height * 0.4, width: containerView.frame.width, height: containerView.frame.height * 0.6)
        }
    }
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        backgroundView = UIView()
        super.init(presentedViewController: presentedViewController, presenting: presentedViewController)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .setColor(.modalBackground)
        tapGestureRecognizer()
    }
    
    func tapGestureRecognizer() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissVC))
        self.backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissVC() {
        self.presentedViewController.dismiss(animated: true)
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView else { return }
        backgroundView.frame = containerView.bounds
        backgroundView.alpha = 0
        containerView.insertSubview(backgroundView, at: 0)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 0.7
        })
    }

    override func dismissalTransitionWillBegin() {
        presentingViewController.beginAppearanceTransition(true, animated: true)
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 0
        })
    }
}
