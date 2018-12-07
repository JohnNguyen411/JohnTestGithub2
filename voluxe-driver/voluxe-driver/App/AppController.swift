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
        self.registerManagers()
    }

    // MARK:- Push notification permissions

    private var pushController: PushRequiredViewController?

    // TODO temporary until designed
    // https://app.asana.com/0/858610969087925/891607760776260/f
    func togglePushRequiredController(allowed: Bool) {

        // controller is presented but no longer necessary
        if let controller = self.pushController, allowed == true {
            controller.dismiss(animated: true) {
                self.pushController?.removeFromParent()
                self.pushController = nil
            }
        }

        // controller is not presented but needs to be
        if self.pushController == nil, allowed == false {
            let controller = PushRequiredViewController()
            self.present(controller, animated: true)
            self.pushController = controller
        }
    }

    // MARK:- Manager support

    private func registerManagers() {

        // when driver changes other managers need to know
        DriverManager.shared.driverDidChangeClosure = {
            driver in
            RequestManager.shared.set(driver: driver)
        }

        RequestManager.shared.requestsDidChangeClosure = {
            requests in
            NSLog("REQUESTS changed to \(requests)")
        }
    }
}

// MARK:- App lifecycle

extension AppController {

    func launch() {
        self.resume()
    }

    func resume() {
        AppDelegate.shared.registerForPushNotifications() {
            [weak self] allowed in
            self?.togglePushRequiredController(allowed: allowed)
            // TODO tell DriverManager that driver token has added or disconnected
        }
    }

    func suspend() {
        UserDefaults.standard.synchronize()
    }

    func exit() {
        UserDefaults.standard.synchronize()
    }
}
