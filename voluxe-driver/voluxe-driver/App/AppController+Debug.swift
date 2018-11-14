//
//  AppController+Debug.swift
//  voluxe-driver
//
//  Created by Christoph on 10/30/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension AppController {

    #if DEBUG
    override var canBecomeFirstResponder : Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        guard self.presentingViewController == nil else { return }
        let controller = DebugSettingsViewController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
    #endif

    // TODO https://app.asana.com/0/858610969087925/911111684210127/f
    // TODO tell any managers to stop operations
    // TODO tell DriverManager.logout()
    // TODO tear down current UI
    func relaunch(_ host: RestAPIHost? = nil) {
        if let host = host {
            UserDefaults.standard.apiHost = host
            DriverAPI.api.host = host
        }
        self.launch()
    }
}
