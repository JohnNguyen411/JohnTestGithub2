//
//  MainViewController+Debug.swift
//  voluxe-customer
//
//  Created by Christoph on 5/2/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation

extension VLSlideMenuController {

#if DEBUG
    override var canBecomeFirstResponder : Bool {
        return true
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        guard self.presentingViewController == nil else { return }
        let controller = DebugSettingsViewController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
#endif
}
