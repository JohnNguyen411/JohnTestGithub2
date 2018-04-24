//
//  VLSlideMenuController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 4/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import SlideMenuControllerSwift

class VLSlideMenuController: SlideMenuController {
    
    func changeMainViewController(_ mainViewController: UIViewController, close: Bool, animated: Bool) {
        
        if close {
            closeLeft()
            closeRight()
        }
        
        if let formerMainViewController = self.mainViewController, let snapShot = formerMainViewController.view.snapshotView(afterScreenUpdates: true), animated {
            mainViewController.view.addSubview(snapShot);
            changeController(mainViewController)
            
            UIView.animate(withDuration: 0.30, animations: {
                snapShot.layer.opacity = 0
            }, completion: { finished in
                snapShot.removeFromSuperview()
            })
        } else {
            changeController(mainViewController)
        }
    }
    
    fileprivate func changeController(_ mainViewController: UIViewController) {
        removeViewController(viewController: self.mainViewController)
        self.mainViewController = mainViewController
        setUpViewController(targetView: mainContainerView, targetViewController: mainViewController)
    }
    
    private func setUpViewController(targetView: UIView, targetViewController: UIViewController?) {
        if let viewController = targetViewController {
            addChildViewController(viewController)
            viewController.view.frame = targetView.bounds
            targetView.addSubview(viewController.view)
            viewController.didMove(toParentViewController: self)
        }
    }
    
    
    private func removeViewController(viewController: UIViewController?) {
        if let _viewController = viewController {
            _viewController.view.layer.removeAllAnimations()
            _viewController.willMove(toParentViewController: nil)
            _viewController.view.removeFromSuperview()
            _viewController.removeFromParentViewController()
        }
    }
    
    override func toggleLeft() {
        super.toggleLeft()
        VLAnalytics.logEventWithName(AnalyticsConstants.eventClickNavigationLeftMenuIcon)
    }
}
