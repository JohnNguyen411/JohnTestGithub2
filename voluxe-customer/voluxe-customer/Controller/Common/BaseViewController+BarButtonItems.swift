//
//  BaseViewController+BarButtonItems.swift
//  voluxe-customer
//
//  Created by Christoph on 7/12/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

/// Class to capture the "Back" bar button item tap and map it to
/// BaseViewController.onBackClicked().  This seems to be the cleanest
/// way to do it.
class VLNavigationController: UINavigationController {

    override func popViewController(animated: Bool) -> UIViewController? {
        let controller = super.popViewController(animated: true)
        if let controller = controller as? BaseViewController { controller.onBackClicked() }
        return controller
    }
}

// MARK:- Bar button items

extension BaseViewController {

    /// Convenience func to set this controller's bar button items.  Currently it is
    /// called during BaseViewController.init(screen).
    ///
    /// Note that the backBarButtonItem does not set the target or action.  This is
    /// because it will never be called.  The default behaviour is to pop the current
    /// view controller of the stack, and UIKit doesn't want this to be broken.
    func setDefaultBarButtonItems() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: .localized(.back), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(onRightClicked))
    }

    /// Default func for when the navigation bar's back item is tapped.
    /// Subclasses MUST call super.onBackClicked() to retain analytics functionality.
    @objc func onBackClicked() {
        Analytics.trackClick(navigation: .back, screen: self.screen)
    }

    /// Default func for when the navigation bar's right item is tapped.
    /// Subclasses MUST call super.onRightClicked() to retain analytics functionality.
    @objc func onRightClicked() {
        Analytics.trackClick(navigation: .next, screen: self.screen)
    }
}

// MARK:- Push

extension BaseViewController {

    /// Convenience func to push a view controller onto the current controller's navigation stack.
    /// This allows for configuration of the back button item title if an alternate is desired.
    func pushViewController(_ controller: UIViewController, animated: Bool, backBarButtonTitle: String? = .localized(.back)) {
        if let title = backBarButtonTitle { controller.navigationItem.backBarButtonItem?.title = title }
        self.navigationController?.pushViewController(controller, animated: animated)
    }
}

// MARK:- Unexpected use of UINavigationController

/// Uncomment this extension and look for deprecation warnings to
/// find out if UINavigationController.pushViewController() is being
/// used instead of VLNavigationController.
//extension UINavigationController {
//
//    @available(*, deprecated)
//    func pushViewController(_ viewController: UIViewController, animated: Bool) {}
//}
