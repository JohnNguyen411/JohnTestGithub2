//
//  AppController+Test.swift
//  voluxe-driver
//
//  Created by Christoph on 11/2/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

// This is provided as a convenient way to exercise code while the
// app is being built.  Simply remove from the target or comment
// to disable, or write your own code to test!
extension AppController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DriverAPI.login(email: "christoph@luxe.com", password: "shenoa7777") {
            driver, error in
            guard let driver = driver else { return }
            DriverAPI.today(for: driver) {
                requests, error in
                NSLog("")
            }
        }
    }
}
