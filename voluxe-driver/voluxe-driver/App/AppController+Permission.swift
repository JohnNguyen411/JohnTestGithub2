//
//  AppController+Permission.swift
//  voluxe-driver
//
//  Created by Christoph on 12/6/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation
import UIKit

extension AppController {

    // Convenience var to get the presented permission controller.
    // Rather than store it as a property, the controller is either
    // managed by the AppController presentation of it, or does not
    // exist.
    //
    // Note that this assumes the permission controller was presented
    // inside of a MainViewController from togglePermissionRequired().
    // If the style of presentation changes there, this will need to
    // be updated as well.
    private var permissionViewController: PermissionViewController? {
        guard let main = self.presentedViewController as? MainViewController else { return nil }
        return main.topViewController as? PermissionViewController
    }

    // Manages the presentation of UI related to a permission.  If a permission
    // was not allowed, appropriate UI is shown.  If UI is already showing for
    // a previously not allowed permission, nothing can happen until that UI
    // is dismissed (by going to Settings and correcting).  If a permission
    // changes from "not allowed" to "allowed", the associated UI will be dismissed.
    //
    // Note that this presents the permission controller hosted in a MainViewController.
    // This is because the design requires the titled navigation bar which is
    // easily obtained by using a MainViewController.  It is presented modally
    // because pushing the permission onto the current main view controller stack
    // would require dumping the entire stack, but then what would dimissing
    // it go back to?  Presenting modally also the current view controller stack to
    // remain intact until this is dismissed, much easier to implement.
    func togglePermissionRequired(_ permission: Permission, allowed: Bool) {

        // controller is not presented but should be for this permission
        if self.permissionViewController == nil, allowed == false {
            let controller = PermissionViewController(permission: permission)
            let main = MainViewController(with: controller, showProfileButton: false)
            self.present(main, animated: true)
        }

        // controller for permission is presented but no longer necessary
        if let controller = self.permissionViewController, permission == controller.permission, allowed == true {
            controller.dismiss(animated: true) {
                controller.removeFromParent()
            }
        }
    }

    // Entry point into the permissions request chain.  This asks for location
    // permissions first, and if allowed, chains to ask push permissions
    // next.  The order can be easily changed, but the important point is
    // that all permissions are asked in order to ensure all permissions
    // have been granted to allow app usage, and that the appropriate UI
    // is shown.
    func requestPermissions() {
        AppDelegate.shared.requestLocationUpdates() {
            [weak self] allowed in
            self?.togglePermissionRequired(.location, allowed: allowed)
            guard allowed == true else { return }
            self?.requestPushPermissions()
        }
    }

    // Second permission that is requested.  Additional permissions
    // should be requested in other private funcs that are called/chained
    // from this func, as shown in requestPermissions().  The order can
    // be changed as necessary.
    private func requestPushPermissions() {
        AppDelegate.shared.requestLocationUpdates() {
            [weak self] allowed in
            self?.togglePermissionRequired(.push, allowed: allowed)
        }
    }
}
