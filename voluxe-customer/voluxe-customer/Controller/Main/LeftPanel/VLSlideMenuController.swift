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

    // Since this subclass is acting as the delegate for itself,
    // we should actively prevent any assignment of the delegate
    // from any part of this sytem.  This is an example of how to
    // change an inherited read-write property to read-only.
    internal override var delegate: SlideMenuControllerDelegate? {
        get { return self }
        set {}
    }

    override func initView() {

        // always do the super
        super.initView()

        // general init
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewScale = 1.0
        SlideMenuOptions.pointOfNoReturnWidth = 0.0
        SlideMenuOptions.shadowOpacity = 0.15
        SlideMenuOptions.shadowRadius = 2.0
        SlideMenuOptions.shadowOffset = CGSize(width: 2, height: 0)

        // init for blurring effect when opened
        SlideMenuOptions.panGesturesEnabled = false
        SlideMenuOptions.animationDuration = 0.25
        SlideMenuOptions.animationOptions = [.curveEaseInOut]
        SlideMenuOptions.opacityViewBackgroundColor = UIColor.clear
        SlideMenuOptions.contentViewOpacity = 0
    }

    func changeMainViewController(_ controller: UIViewController, close: Bool, animated: Bool) {
        
        if close {
            closeLeft()
            closeRight()
        }

        // swap controllers
        self.removeViewController(controller: self.mainViewController)
        self.addChild(controller)
        self.mainViewController = controller

        // swap controller views
        controller.view.frame = self.mainContainerView.bounds
        self.mainContainerView.addSubviewBelowBlurredView(subview: controller.view)
        controller.didMove(toParent: self)
    }

    private func removeViewController(controller: UIViewController?) {
        guard let controller = controller else { return }
        controller.view.layer.removeAllAnimations()
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }

    override func track(_ trackAction: SlideMenuController.TrackAction) {
        if trackAction == .leftTapClose { Analytics.trackClick(navigation: .close) }
        else if trackAction == .leftTapOpen { Analytics.trackClick(navigation: .menu) }
    }

}

// MARK:- Global blur support

extension VLSlideMenuController {

    func blur(animated: Bool = true) {
        self.mainContainerView.blurByLuxe()
    }

    func unblur(animated: Bool = true) {
        self.mainContainerView.unblurByLuxe()
    }
}

// MARK:- SlideMenuControllerDelegate

extension VLSlideMenuController: SlideMenuControllerDelegate {

    func leftWillOpen() {
        self.mainContainerView.blurByLuxe(duration: TimeInterval(SlideMenuOptions.animationDuration))
    }

    func leftWillClose() {
        self.mainContainerView.unblurByLuxe(duration: TimeInterval(SlideMenuOptions.animationDuration))
    }
}
