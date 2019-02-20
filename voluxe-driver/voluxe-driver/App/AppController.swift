//
//  AppController.swift
//  voluxe-driver
//
//  Created by Christoph on 10/16/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

class AppController: UIViewController {

    // MARK: Singleton

    static let shared = AppController()

    // MARK: Lifecycle

    private init() {
        super.init(nibName: nil, bundle: nil)
        self.registerAPINotifications()
        
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).numberOfLines = 0
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).lineBreakMode = .byWordWrapping
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        self.deregisterAPINotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.associateManagers()
    }

    private func associateManagers() {
        DriverManager.shared.driverDidChangeClosure = {
            driver in
            RequestManager.shared.set(driver: driver)
        }
    }
}

// MARK:- App lifecycle

extension AppController {

    func launch() {
        self.showLanding(animated: false)
    }

    func resume() {
        if UserDefaults.standard.hasAskedPushPermission {
            AppController.shared.requestPushPermissions()
        }
        if UserDefaults.standard.hasAskedLocationPermission {
            AppController.shared.requestLocationPermissions()
        }
        
    }

    func suspend() {
        UserDefaults.standard.synchronize()
    }

    func exit() {
        UserDefaults.standard.synchronize()
    }

    func logout() {
        DriverManager.shared.logout()
        RequestManager.shared.stop()
        UploadManager.shared.stop()
        self.showLanding()
    }
}

// MARK:- Controller support

extension AppController {

    /// The AppController only allows one active child controller at a time.
    /// Hence `replaceChildController` should be used instead of the usual
    /// addChild(controller) and removeChild(controller) funcs.  This func
    /// also provides an optional animation to transition between the controllers.
    ///
    /// IMPORTANT!
    /// Because these are "primary" controllers and most likely fullscreen, they
    /// are placed WITHOUT safe area.  This means that the views inside the controller
    /// need to be placed with safe areas.
    func replaceChildController(with controller: UIViewController, animated: Bool = true) {

        assert(self.children.count <= 1, "AppController should never have more than one child controller")
        let oldController = self.children.first
        oldController?.removeFromParent()

        self.addChild(controller)
        Layout.fill(view: self.view, with: controller.view, useSafeArea: false)
        controller.view.alpha = 0

        UIView.animate(withDuration: animated ? 0.3 : 0,
                       animations:
            {
                controller.view.alpha = 1
                oldController?.view.alpha = 0
            },
                       completion:
            {
                finished in
                controller.didMove(toParent: self)
                oldController?.view.removeFromSuperview()
                oldController?.didMove(toParent: nil)
            })
    }
}

// MARK:- Specific controller support

extension AppController {

    func showLanding(animated: Bool = true) {
        let controller = LandingViewController()
        self.replaceChildController(with: controller, animated: animated)
    }

    func showMain(animated: Bool = true, rootViewController: UIViewController? = nil, showProfileButton: Bool = true) {
        let controller = MainViewController(with: rootViewController, showProfileButton: showProfileButton)
        self.replaceChildController(with: controller, animated: animated)
    }

    // MARK: Profile controller

    // The profile controller is different than other child controllers
    // because it acts as an overlay first, then will replace the child
    // controller if interacted with.  So, it is modally presented without
    // animation so that it's own animation can run as a transition.
    func showProfile(animated: Bool = true) {
        guard self.presentedViewController == nil else { return }
        let controller = ProfileViewController()
        controller.preparePresentAnimation()
        self.present(controller, animated: false) {
            controller.playPresentAnimation()
        }
    }

    // Dismisses the profile controller (if presented).  Note that the
    // controller will perform it's own animation before the dismiss.
    func hideProfile(animated: Bool = true) {
        guard let controller = self.presentedViewController as? ProfileViewController else { return }
        controller.playDismissAnimation() {
            controller.dismiss(animated: false, completion: nil)
        }
    }

    // MARK: Push to the main view controller

    var mainController: MainViewController? {
        return self.children.first as? MainViewController
    }

    func mainController(push controller: UIViewController,
                        animated: Bool = true,
                        asRootViewController: Bool = false,
                        prefersProfileButton: Bool? = nil)
    {
        guard let main = self.children.first as? MainViewController else { return }
        if asRootViewController { main.setViewControllers([controller], animated: animated) }
        else { main.pushViewController(controller, animated: animated) }
        guard let prefers = prefersProfileButton else { return }
        if prefers { main.showProfileButton(animated: animated) }
        else { main.hideProfileButton(animated: animated) }
    }
    
    var presentedController: UIViewController? {
        return self.children.first
    }
}
