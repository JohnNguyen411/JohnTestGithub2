//
//  LocationManager.swift
//  Volvo Driver
//
//  Created by Giroux, Johan on 10/20/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit
import GooglePlaces

typealias LMLocationCompletionHandler = ((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())?

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private static let defaultMinDistanceFilter = 5.0
    
    /* Private variables */
    fileprivate var completionHandler: LMLocationCompletionHandler
    
    fileprivate var googlePlacesClient: GMSPlacesClient!
    fileprivate var googleGeocoder: GMSGeocoder!

    fileprivate var locationStatus: NSString = "Calibrating"// to pass in handler
    fileprivate var verboseMessage = "Calibrating"
    
    fileprivate let verboseMessageDictionary = [CLAuthorizationStatus.notDetermined:"You have not yet made a choice with regards to this application.",
                                                CLAuthorizationStatus.restricted:"This application is not authorized to use location services. Due to active restrictions on location services, the user cannot change this status, and may not have personally denied authorization.",
                                                CLAuthorizationStatus.denied:"You have explicitly denied authorization for this application, or location services are disabled in Settings.",
                                                CLAuthorizationStatus.authorizedAlways:"App is Authorized to use location services.",
                                                CLAuthorizationStatus.authorizedWhenInUse:"You have granted authorization to use your location only when the app is visible to you."]
    
    
    weak var delegate: LocationManagerDelegate? = nil
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var latitudeAsString: String = ""
    var longitudeAsString: String = ""
    
    var lastKnownLatitude: Double = 0.0
    var lastKnownLongitude:Double = 0.0
    
    var lastKnownLatitudeAsString: String = ""
    var lastKnownLongitudeAsString: String = ""
    
    var keepLastKnownLocation: Bool = true
    var hasLastKnownLocation: Bool = true
    var autoUpdate: Bool = false
    var permissionAlways: Bool = false
    var showVerboseMessage = false
    var isRunning = false
    
    var locationManager = CLLocationManager()

    
    class var sharedInstance: LocationManager {
        struct Static {
            static let instance = LocationManager()
        }
        return Static.instance
    }
    
    
    fileprivate override init() {
        googlePlacesClient = GMSPlacesClient()
        googleGeocoder = GMSGeocoder()
        
        super.init()
        
        if (!autoUpdate) {
            autoUpdate = !CLLocationManager.significantLocationChangeMonitoringAvailable()
        }
    }
    
    fileprivate func resetLatLon() {
        
        latitude = 0.0
        longitude = 0.0
        
        latitudeAsString = ""
        longitudeAsString = ""
    }
    
    fileprivate func resetLastKnownLatLon() {
        
        hasLastKnownLocation = false
        
        lastKnownLatitude = 0.0
        lastKnownLongitude = 0.0
        
        lastKnownLatitudeAsString = ""
        lastKnownLongitudeAsString = ""
    }
    
    func startUpdatingLocationWithCompletionHandler(_ completionHandler:((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())? = nil) {
        self.completionHandler = completionHandler
        initLocationManager()
    }
    
    
    func startUpdatingLocation() {
        initLocationManager()
    }
    
    func stopUpdatingLocation(){
        if (autoUpdate) {
            locationManager.stopUpdatingLocation()
        } else {
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        
        resetLatLon()
        if (!keepLastKnownLocation) {
            resetLastKnownLatLon()
        }
    }
    
    fileprivate func initLocationManager() {
        
        // App might be unreliable if someone changes autoupdate status in between and stops it
       
        locationManager.delegate = self
        locationManager.distanceFilter = CLLocationDistance(LocationManager.defaultMinDistanceFilter)
        // locationManager.locationServicesEnabled
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let Device = UIDevice.current
        
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        
        let iOS8 = iosVersion >= 8
        
        if iOS8 {
            if UIApplication.isRunningTest || !permissionAlways {
                locationManager.requestWhenInUseAuthorization() // add in plist NSLocationWhenInUseUsageDescription
            } else {
                locationManager.requestAlwaysAuthorization() // add in plist NSLocationAlwaysUsageDescription
            }
        }
        
        startLocationManger()
    }
    
    fileprivate func startLocationManger(){
        
        if (autoUpdate) {
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startMonitoringSignificantLocationChanges()
        }
        
        isRunning = true
    }
    
    
    fileprivate func stopLocationManger(){
        
        if (autoUpdate) {
            locationManager.stopUpdatingLocation()
        } else {
            locationManager.stopMonitoringSignificantLocationChanges()
        }
        
        isRunning = false
    }
    
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        stopLocationManger()
        resetLatLon()
        
        if (!keepLastKnownLocation) {
            resetLastKnownLatLon()
        }
        
        var verbose = ""
        if showVerboseMessage {verbose = verboseMessage}
        completionHandler?(0.0, 0.0, locationStatus as String, verbose,error.localizedDescription)
        
        if let delegate = self.delegate, delegate.responds(to: #selector(LocationManagerDelegate.locationManagerReceivedError(_:))) {
            delegate.locationManagerReceivedError!(error.localizedDescription as NSString)
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let arrayOfLocation = locations as NSArray
        let location = arrayOfLocation.lastObject as! CLLocation
        let coordLatLon = location.coordinate
        
        latitude = coordLatLon.latitude
        longitude = coordLatLon.longitude
        
        latitudeAsString = coordLatLon.latitude.description
        longitudeAsString = coordLatLon.longitude.description
        
        var verbose = ""
        
        if showVerboseMessage {verbose = verboseMessage}
        
        if (completionHandler != nil) {
            completionHandler?(latitude, longitude, locationStatus as String,verbose, nil)
        }
        
        lastKnownLatitude = coordLatLon.latitude
        lastKnownLongitude = coordLatLon.longitude
        
        lastKnownLatitudeAsString = coordLatLon.latitude.description
        lastKnownLongitudeAsString = coordLatLon.longitude.description
        
        hasLastKnownLocation = true
        
        if let delegate = self.delegate {
            if (delegate.responds(to: #selector(LocationManagerDelegate.locationFoundGetAsString(_:longitude:)))) {
                delegate.locationFoundGetAsString!(latitudeAsString as NSString, longitude: longitudeAsString as NSString)
            }
            if (delegate.responds(to: #selector(LocationManagerDelegate.locationFound(_:longitude:)))) {
                delegate.locationFound(latitude, longitude:longitude)
            }
        }
    }
    
    
    internal func locationManager(_ manager: CLLocationManager,
                                  didChangeAuthorization status: CLAuthorizationStatus) {
        var hasAuthorised = false
        let verboseKey = status
        switch status {
        case CLAuthorizationStatus.restricted:
            locationStatus = "Restricted Access"
        case CLAuthorizationStatus.denied:
            locationStatus = "Denied access"
        case CLAuthorizationStatus.notDetermined:
            locationStatus = "Not determined"
        default:
            locationStatus = "Allowed access"
            hasAuthorised = true
        }
        
        verboseMessage = verboseMessageDictionary[verboseKey]!
        
        if (hasAuthorised == true) {
            startLocationManger()
        } else {
            
            resetLatLon()
            if (!locationStatus.isEqual(to: "Denied access")) {
                
                var verbose = ""
                if showVerboseMessage {
                    
                    verbose = verboseMessage
                    
                    if let delegate = self.delegate, delegate.responds(to: #selector(LocationManagerDelegate.locationManagerVerboseMessage(_:))) {
                        delegate.locationManagerVerboseMessage!(verbose as NSString)
                    }
                }
                
                if (completionHandler != nil) {
                    completionHandler?(latitude, longitude, locationStatus as String, verbose,nil)
                }
            }
            if let delegate = self.delegate, delegate.responds(to: #selector(LocationManagerDelegate.locationManagerStatus(_:))) {
                delegate.locationManagerStatus!(locationStatus)
            }
        }
    }
    
    func authorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    func isAuthorizationGranted() -> Bool {
        let status = authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            return true
        }
        return false
    }
    
    func canUpdateLocation() -> Bool {
        return isAuthorizationGranted() && CLLocationManager.locationServicesEnabled()
    }
    
    
    func googlePlacesAutocomplete(address: String, onAutocompleteCompletionHandler: @escaping GMSAutocompletePredictionsCallback) {
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        var bounds: GMSCoordinateBounds? = nil
        if let location = locationManager.location {
            bounds = GMSCoordinateBounds(coordinate: location.coordinate, coordinate: location.coordinate)
        }
        
        googlePlacesClient.autocompleteQuery(address, bounds: bounds, boundsMode: .bias, filter: filter, callback: { (autocompletePredictions, error) in
        
            var filteredPredictions:[GMSAutocompletePrediction] = []
            if let autocompletePredictions = autocompletePredictions {
                for prediction in autocompletePredictions {
                    var shouldAdd = false
                    for type in prediction.types {
                        if type == "premise" || type == "street_number" || type == "street_address" || type == "establishment" || type == "route" {
                            shouldAdd = true
                            break
                        }
                    }
                    if shouldAdd {
                        filteredPredictions.append(prediction)
                    }
                }
            }
            
             onAutocompleteCompletionHandler(filteredPredictions, error)
        })
    }
 
    func reverseGeocodeLocation(latitude:Double, longitude: Double, completionHandler: @escaping GMSReverseGeocodeCallback) {
        googleGeocoder.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: latitude, longitude: longitude), completionHandler: completionHandler)
    }
    
    func getPlace(placeId: String, callback: @escaping GMSPlaceResultCallback) {
        googlePlacesClient.lookUpPlaceID(placeId, callback: callback)
    }
    
}

@objc protocol LocationManagerDelegate : NSObjectProtocol
{
    func locationFound(_ latitude:Double, longitude:Double)
    @objc optional func locationFoundGetAsString(_ latitude:NSString, longitude:NSString)
    @objc optional func locationManagerStatus(_ status:NSString)
    @objc optional func locationManagerReceivedError(_ error:NSString)
    @objc optional func locationManagerVerboseMessage(_ message:NSString)
}
