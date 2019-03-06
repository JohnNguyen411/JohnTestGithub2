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
        self.presentDebugMenu()
    }

    func presentDebugMenu() {
        guard self.presentingViewController == nil else { return }
        let controller = DebugSettingsViewController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
    #endif

    func relaunch(_ host: RestAPIHost? = nil) {

        // remove any serialized content since the host
        // has changed so URLs will be incorrect
        DriverManager.shared.logout()
        RequestManager.shared.clear()
        RequestManager.shared.stop()
        UploadManager.shared.clear()
        UploadManager.shared.stop()

        // reset API and relaunch
        if let host = host {
            UserDefaults.standard.apiHost = host
            DriverAPI.api.host = host
        }
        self.launch()
    }
}
