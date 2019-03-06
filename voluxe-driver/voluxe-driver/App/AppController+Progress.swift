//
//  AppController+Progress.swift
//  voluxe-driver
//
//  Created by Christoph on 1/4/19.
//  Copyright © 2019 Luxe By Volvo. All rights reserved.
//

import Foundation
import MBProgressHUD
import UIKit

extension AppController {
    
    func lookBusy() {
        Thread.assertIsMainThread()
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }

    func lookNotBusy() {
        Thread.assertIsMainThread()
        guard let hud = MBProgressHUD(for: self.view) else { return }
        hud.hide(animated: true)
    }
    
    func isBusy() -> Bool {
        guard MBProgressHUD(for: self.view) != nil else {
            return false
        }
        return true
    }
}
