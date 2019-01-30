//
//  DriverManager.swift
//  voluxe-driver
//
//  Created by Christoph on 11/1/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

class DriverManager: NSObject, CLLocationManagerDelegate {

    static let shared = DriverManager()
    private override init() {
        super.init()
        self.locationManager.delegate = self
    }

    // MARK:- Current driver

    private var _driver: Driver? {
        didSet {
            if let oldDriver = oldValue, let driver = self._driver, oldDriver.id == driver.id {
                // just update the driver
            } else {
                self.notifyDriverDidChange()
            }
            self.refreshPhotoForDriverIfNecessary(oldValue?.photoUrl)
        }
    }

    var driver: Driver? {
        return self._driver
    }

    // MARK:- Current driver image

    private var _driverPhoto: UIImage? {
        didSet {
            self.notifyDriverPhotoDidChange()
        }
    }

    var driverPhoto: UIImage? {
        return self._driverPhoto
    }

    /// Provided as a convenience if UI requires the most up-to-date
    /// photo possible.  Typically when the Driver object is updated,
    /// the photo will be requested if the URL has changed so clients
    /// can simply use driverPhoto and register for driverPhotoDidChange.
    func photoForDriver(completion: @escaping ((UIImage?) -> ())) {

        guard let driver = self.driver else {
            Log.unexpected(.missingValue, "Cannot get drive image without an active driver")
            DispatchQueue.main.async { completion(nil) }
            return
        }

        guard let photoUrl = driver.photoUrl else {
            Log.unexpected(.incorrectValue, "Driver.photoUrl is nil")
            DispatchQueue.main.async { completion(nil) }
            return
        }
        
        guard let url = URL(string: photoUrl) else {
            Log.unexpected(.incorrectValue, "Driver.photoUrl is an invalid URL")
            DispatchQueue.main.async { completion(nil) }
            return
        }

        let task = URLSession.shared.dataTask(with: url) {
            [weak self] data, response, error in
            let image = data != nil ? UIImage(data: data!) : nil
            DispatchQueue.main.async() {
                completion(image)
                self?._driverPhoto = image
            }
        }

        task.resume()
    }

    func set(image: UIImage, completion: @escaping ((Bool) -> ())) {
        guard let driver = self.driver else { return }
        guard let image = image.resized(to: 500) else { return }
        DriverAPI.update(photo: image, for: driver) {
            error in
            if let error = error { Log.unexpected(.apiError, error.rawValue) }
            else { self._driverPhoto = image }
            completion(error == nil)
        }
    }

    private func refreshPhotoForDriverIfNecessary(_ oldPhotoUrl: String?) {
        guard let driver = self.driver else { return }
        if oldPhotoUrl != nil && driver.photoUrl == oldPhotoUrl { return }
        self.photoForDriver() {
            [weak self] photo in
            self?._driverPhoto = photo
        }
    }

    // MARK:- Log in/out

    var isLoggedIn: Bool {
        return self.driver != nil
    }

    func login(email: String,
               password: String,
               completion: @escaping ((Driver?, LuxeAPIError?) -> ()))
    {
        if let driver = self._driver, driver.email == email {
            DispatchQueue.main.async() { completion(driver, nil) }
            return
        }

        DriverAPI.login(email: email, password: password) {
            driver, error in
            if error == nil { self._driver = driver }
            completion(driver, error)
            self.updateDriverWithToken()
        }
    }
    
    func me(completion: @escaping ((Driver?, LuxeAPIError?) -> ()))
    {
        
        // No need to authenticate, we are using token to retrieve `/me`
        DriverAPI.me() {
            driver, error in
            if error == nil { self._driver = driver }
            completion(driver, error)
            self.updateDriverWithToken()
        }
    }

    func logout() {
        DriverAPI.logout()
        self.stopLocationUpdates()
        self._driver = nil
        self._location = nil
    }

    // MARK:- Location updates

    private var _location: CLLocation? {
        didSet {
            self.notifyLocationDidChange()
        }
    }

    var location: CLLocation? {
        return self._location
    }

    private let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.activityType = .automotiveNavigation
        return manager
    }()

    private var _isUpdatingLocation: Bool = false
    var isUpdatingLocation: Bool {
        return self._isUpdatingLocation
    }

    var canUpdateLocation: Bool {
        return self.isLoggedIn && CLLocationManager.authorizationStatus() == .authorizedAlways
    }

    func startLocationUpdates() {
        guard self.canUpdateLocation else { return }
        self._isUpdatingLocation = true
        self.locationManager.startUpdatingLocation()
    }

    func stopLocationUpdates() {
        self._isUpdatingLocation = false
        self.locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation])
    {
        guard let location = locations.first else { return }
        guard let driver = self.driver else { return }
        DriverAPI.update(location: location.coordinate, for: driver) {
            error in
            guard let error = error else { return }
            Log.unexpected(.apiError, "\(error)")
        }
        self._location = location
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error)
    {
        Log.unexpected(.locationError, "\(error)")
    }

    // MARK:- Push notification token

    private var _pushToken: String? {
        didSet {
            self.notifyPushTokenDidChange()
        }
    }

    var pushToken: String? {
        return self._pushToken
    }

    func set(push token: String?) {
        self._pushToken = token
        self.updateDriverWithToken()
    }

    // TODO https://app.asana.com/0/858610969087925/941718004229101/f
    // TODO does this need to repeat until it works?
    private func updateDriverWithToken() {
        guard let driver = self.driver else { return }
        guard let token = self.pushToken else { return }
        DriverAPI.register(device: token, for: driver) {
            error in
            if let error = error {
                Log.unexpected(.apiError, "Could not update driver with push token: \(error)")
            }
        }
    }

    // MARK:- Notifications

    var driverDidChangeClosure: ((Driver?) -> ())?

    private func notifyDriverDidChange() {
        self.driverDidChangeClosure?(self.driver)
    }

    var driverPhotoDidChangeClosure: ((UIImage?) -> ())?

    private func notifyDriverPhotoDidChange() {
        self.driverPhotoDidChangeClosure?(self.driverPhoto)
    }

    var locationDidChangeClosure: ((CLLocation?) -> ())?

    private func notifyLocationDidChange() {
        self.locationDidChangeClosure?(self.location)
    }

    var pushTokenDidChangeClosure: ((String?) -> ())?

    private func notifyPushTokenDidChange() {
        self.pushTokenDidChangeClosure?(self.pushToken)
    }
}
