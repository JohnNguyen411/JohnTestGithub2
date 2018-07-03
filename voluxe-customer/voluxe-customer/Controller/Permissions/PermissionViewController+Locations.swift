//
//  PermissionViewController+Locations.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 5/18/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftEventBus

extension PermissionViewController: CLLocationManagerDelegate {
    
    func requestLocationPermission() {
        let status = LocationManager.sharedInstance.authorizationStatus()
        if (status == CLAuthorizationStatus.notDetermined) {
            let locationManager = LocationManager.sharedInstance.locationManager
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let granted = status == .authorizedWhenInUse || status == .authorizedAlways
        Analytics.trackChangePermission(permission: .location, granted: granted, screen: self.screen)
        SwiftEventBus.post("onLocationPermissionStatusChanged")
        self.dismiss(animated: true)

    }
    
}
