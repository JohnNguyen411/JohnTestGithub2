//
//  LocationUtils.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/17/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import CoreLocation

class LocationUtils {
    
    // Docs: https://www.waze.com/about/dev
    private static let wazeAppURL = "waze://";
    private static let wazeCoordinateQueryFormat = "?ll=%.8f,%.8f&navigate=yes&z=10";
    private static let wazeAddressQueryFormat = "?q=%@&navigate=yes&z=10";
    
    // Docs: https://developers.google.com/maps/documentation/ios/urlscheme
    private static let googleMapsAppURL = "comgooglemaps://";
    private static let googleMapsWebURL = "http://maps.google.com";
    private static let googleMapsCoordinateQueryFormat = "?q=%.8f,%.8f&center=%f,%f&views=traffic&zoom=15";
    private static let googleMapsAddressQueryFormat = "?q=%@&views=traffic&zoom=15";
    
    // Docs: https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html#//apple_ref/doc/uid/TP40007894-SW1
    private static let appleMapsWebURL = "http://maps.apple.com";
    private static let appleMapsCoordinateQueryFormat = "?daddr=%.8f,%.8f&z=15";
    private static let appleMapsAddressQueryFormat = "?daddr=%@&z=15";
    
    
    //MARK: - Navigating to Coordinates
    
    static func launchNavigationToLocation(location: CLLocation, usingWaze: Bool) {
        if usingWaze {
            // Try to use Waze if it's installed
            if openLocationWithWazeNativeApp(location: location) {
                return
            }
        }
        
        // Try to use Google Maps if it's installed
        if openLocationWithGoogleMapsNativeApp(location: location) {
            return
        }
        
        // Try to use Apple Maps
        if openLocationWithAppleMapsNativeApp(location: location) {
            return
        }
        
        // Try to launch Google Maps in web browser
        if openLocationWithGoogleMapsWebApp(location: location) {
            return
        }
    }
        
   
    static func openLocationWithWazeNativeApp(location: CLLocation) -> Bool {
        if let url = self.urlWithPrefix(prefix: wazeAppURL, format: wazeCoordinateQueryFormat, location: location) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
    
    static func openLocationWithGoogleMapsNativeApp(location: CLLocation) -> Bool {
        if let url = self.urlWithPrefix(prefix: googleMapsAppURL, format: googleMapsCoordinateQueryFormat, location: location) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
    
    static func openLocationWithGoogleMapsWebApp(location: CLLocation) -> Bool {
        if let url = self.urlWithPrefix(prefix: googleMapsWebURL, format: googleMapsCoordinateQueryFormat, location: location) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
    
    static func openLocationWithAppleMapsNativeApp(location: CLLocation) -> Bool {
        if let url = self.urlWithPrefix(prefix: appleMapsWebURL, format: appleMapsCoordinateQueryFormat, location: location) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
    
    //MARK: - Navigating to Address

    static func launchNavigationToAddress(address: String, usingWaze: Bool) {
        if usingWaze {
            // Try to use Waze if it's installed
            if openAddressWithWazeNativeApp(address: address) {
                return
            }
        }
        
        // Try to use Google Maps if it's installed
        if openAddressWithGoogleMapsNativeApp(address: address) {
            return
        }
        
        // Try to use Apple Maps
        if openAddressWithAppleMapsNativeApp(address: address) {
            return
        }
        
        // Try to launch Google Maps in web browser
        if openAddressWithGoogleMapsWebApp(address: address) {
            return
        }
    }
   
    static func openAddressWithWazeNativeApp(address: String) -> Bool {
        if let url = self.urlWithPrefix(prefix: wazeAppURL, format: wazeAddressQueryFormat, address: address) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
    
    static func openAddressWithGoogleMapsNativeApp(address: String) -> Bool {
        if let url = self.urlWithPrefix(prefix: googleMapsAppURL, format: googleMapsAddressQueryFormat, address: address) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
    
    static func openAddressWithGoogleMapsWebApp(address: String) -> Bool {
        if let url = self.urlWithPrefix(prefix: googleMapsWebURL, format: googleMapsAddressQueryFormat, address: address) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
    
    static func openAddressWithAppleMapsNativeApp(address: String) -> Bool {
        if let url = self.urlWithPrefix(prefix: appleMapsWebURL, format: appleMapsAddressQueryFormat, address: address) {
            UIApplication.shared.open(url)
            return true
        }
        return false
    }
    
    
    class func getLocation(stringLocation: String?) -> CLLocationCoordinate2D? {
        var location: CLLocationCoordinate2D?
        if let stringLocation = stringLocation {
            if let indexStartOfcoma = stringLocation.index(of: ",") {
                
                let lat = stringLocation[...indexStartOfcoma]
                let long = stringLocation[indexStartOfcoma...]
                
                if let degLat = CLLocationDegrees(lat), let degLong = CLLocationDegrees(long) {
                    location = CLLocationCoordinate2DMake(degLat, degLong)
                }
            }
        }
        return location
    }
    
    
    //MARK: - String Helpers
    
    private static func urlWithPrefix(prefix: String, format: String, location: CLLocation) -> URL? {
        return URL(string: "\(prefix)\(queryStringWithFormat(format: format, location: location))")
    }
    
    private static func queryStringWithFormat(format: String, location: CLLocation) -> String {
        if format == googleMapsCoordinateQueryFormat {
            return String(format: format, location.coordinate.latitude, location.coordinate.longitude, location.coordinate.latitude, location.coordinate.longitude)
        } else {
            return String(format: format, location.coordinate.latitude, location.coordinate.longitude)
        }
    }
    
    private static func urlWithPrefix(prefix: String, format: String, address: String) -> URL? {
        return URL(string: "\(prefix)\(queryStringWithFormat(format: format, address: address))")
    }
    
    private static func queryStringWithFormat(format: String, address: String) -> String {
        return String(format: format, address)
    }
    
}
