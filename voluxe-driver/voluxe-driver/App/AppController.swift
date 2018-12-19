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

    static let shared = AppController()

    // MARK:- Lifecycle

    private init() {
        super.init(nibName: nil, bundle: nil)
        self.registerAPINotifications()
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

    // MARK:- Manager support

    private func associateManagers() {

        // TODO if driver becomes nil, need to force logout
        // when driver changes other managers need to know
        DriverManager.shared.driverDidChangeClosure = {
            driver in
            RequestManager.shared.set(driver: driver)
        }
    }
}

// MARK:- App lifecycle

extension AppController {

    func launch() {
        // TODO resume() is called just for simplicity
        // launch behaviour will be different
        self.showLanding(animated: false)
        self.resume()
    }

    func resume() {
        self.requestPermissions()
    }

    func suspend() {
        UserDefaults.standard.synchronize()
    }

    func exit() {
        UserDefaults.standard.synchronize()
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
    private func replaceChildController(with controller: UIViewController, animated: Bool = true) {

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

    func showMain(animated: Bool = true) {
        let controller = MainViewController()
        self.replaceChildController(with: controller, animated: animated)
    }

    func showToday(animated: Bool = true) {
        let controller = UIViewController(nibName: nil, bundle: nil)
        controller.view.backgroundColor = UIColor.Debug.red
        let button = UIButton(type: .custom).usingAutoLayout()
        button.setTitle("Close", for: .normal)
        controller.view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(closeButtonTouchUpInside), for: .touchUpInside)
        self.replaceChildController(with: controller)
    }

    // TODO remove, this is temporary to test replacing controllers
    @objc func closeButtonTouchUpInside() {
        AppController.shared.showLanding()
    }
}
