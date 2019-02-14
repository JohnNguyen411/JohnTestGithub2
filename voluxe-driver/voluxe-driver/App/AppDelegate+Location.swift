//
//  AppDelegate+Location.swift
//  voluxe-driver
//
//  Created by Christoph on 12/6/18.
//  Copyright © 2018 Luxe By Volvo. All rights reserved.
//

import CoreLocation
import Foundation

// Implementations of CLLocationManager often wrap it in a singleton
// with callbacks.  There is nothing wrong with that approach, so this
// is an experiment to see if there is an advantage to coupling a bit
// closer with the AppDelegate.  There already is an ownership between
// AppDelegate and AppController, and it feels cleaner to be able to
// react to app foreground/background events directly from the AppDelegate,
// then forward on to the AppController for UI reactions.  This frees
// other services, like the RequestManager, from having to interact
// with the location singleton, and can instead use a local instance of
// CLLocationManager strictly for location changes.
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
    
    static func distanceBetween(startLocation: CLLocation, endLocation: CLLocation) -> CLLocationDistance {
        return startLocation.distance(from: endLocation) // result is in meters
    }
}

/// The app only needs a single CLLocationManager, so this is a convenient
/// way to turn it into a singleton without exposing the detail elsewhere
/// in the code.
fileprivate var requestLocationUpdatesCompletion: ((Bool) -> ())?

fileprivate extension CLLocationManager {
    static let local = CLLocationManager()
}
