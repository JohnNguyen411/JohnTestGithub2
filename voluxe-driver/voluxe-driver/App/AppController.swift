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
        // TODO resume() is called just for simplicity
        // launch behaviour will be different
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
