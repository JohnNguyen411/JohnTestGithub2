//
//  AppDelegate+Location.swift
//  voluxe-driver
//
//  Created by Christoph on 12/6/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import CoreLocation
import Foundation

// TODO https://app.asana.com/0/858610969087925/892091539851886/f
// TODO documentation explaining why location permission
// and location tracking are split between the delegate
// and DriverManager, as opposed to a singular LocationManager.
extension AppDelegate: CLLocationManagerDelegate {

    func initLocationUpdates() {
        CLLocationManager.local.delegate = self
    }

    func requestLocationUpdates(completion: ((Bool) -> ())? = nil) {

        Thread.assertIsMainThread()

        guard CLLocationManager.locationServicesEnabled() else {
            DispatchQueue.main.async { completion?(true) }
            return
        }

        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways {
            DispatchQueue.main.async { completion?(true) }
        }

        else if status == .notDetermined {
            requestLocationUpdatesCompletion = completion
            CLLocationManager.local.requestAlwaysAuthorization()
        }

        else {
            DispatchQueue.main.async { completion?(false) }
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus)
    {
        guard let completion = requestLocationUpdatesCompletion else { return }
        let allowed = status == .authorizedAlways
        completion(allowed)
    }
}

// TODO this works but is it too clever?
// TODO does this need to cleaned up after request completes?
fileprivate let locationManager = CLLocationManager()
fileprivate var requestLocationUpdatesCompletion: ((Bool) -> ())?

fileprivate extension CLLocationManager {

    static var local: CLLocationManager {
        return locationManager
    }
}
