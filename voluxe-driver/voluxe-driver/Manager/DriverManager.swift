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

    private var _driver: Driver? {
        didSet {
            self.notifyDriverDidChange()
        }
    }

    var driver: Driver? {
        return self._driver
    }

    // MARK:- Log in/out

    func login(email: String,
               password: String,
               completion: @escaping ((Driver?) -> ()))
    {
        if let driver = self._driver, driver.email == email {
            DispatchQueue.main.async() { completion(driver) }
            return
        }

        DriverAPI.login(email: email, password: password) {
            driver, error in
            if error == nil { self._driver = driver }
            completion(driver)
        }
    }

    func logout() {
        self._driver = nil
        DriverAPI.logout()
    }

    // MARK:- Notifications

    var driverDidChangeClosure: ((Driver?) -> ())?

    private func notifyDriverDidChange() {
        self.driverDidChangeClosure?(self.driver)
    }
}
