//
//  DriverManager.swift
//  voluxe-driver
//
//  Created by Christoph on 11/1/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import Foundation

class DriverManager {

    static let shared = DriverManager()
    private init() {}

    // MARK:- Current driver

    private var driver: Driver?

    // TODO this is temporary
    func currentDriver(completion: @escaping (Driver?) -> ()) {

        if let driver = self.driver {
            DispatchQueue.main.async() { completion(driver) }
            return
        }

        DriverAPI.login(email: "christoph@luxe.com", password: "shenoa7777") {
            driver, error in
            completion(driver)
        }
    }
}
