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

typealias LMReverseGeocodeCompletionHandler = ((_ reverseGecodeInfo:NSDictionary?,_ placemark:CLPlacemark?, _ error:String?)->Void)?
typealias LMGeocodeCompletionHandler = ((_ gecodeInfo:NSDictionary?,_ placemark:CLPlacemark?, _ error:String?)->Void)?
typealias LMAutocompleteCompletionHandler = ((_ gecodeInfos:[NSDictionary]?,_ placemarks:[CLPlacemark]?, _ error:String?)->Void)?
typealias LMLocationCompletionHandler = ((_ latitude:Double, _ longitude:Double, _ status:String, _ verboseMessage:String, _ error:String?)->())?

// Todo: Keep completion handler differerent for all services, otherwise only one will work
enum GeoCodingType{
    
    case geocoding
    case reverseGeocoding
}

class LocationManager: NSObject,CLLocationManagerDelegate {
    
    /* Private variables */
    fileprivate var completionHandler: LMLocationCompletionHandler
    
    fileprivate var reverseGeocodingCompletionHandler: LMReverseGeocodeCompletionHandler
    fileprivate var geocodingCompletionHandler: LMGeocodeCompletionHandler
    fileprivate var autocompleteCompletionHandler: LMAutocompleteCompletionHandler

    fileprivate var locationStatus: NSString = "Calibrating"// to pass in handler
    fileprivate var locationManager: CLLocationManager!
    fileprivate var verboseMessage = "Calibrating"
    
    fileprivate let verboseMessageDictionary = [CLAuthorizationStatus.notDetermined:"You have not yet made a choice with regards to this application.",
                                                CLAuthorizationStatus.restricted:"This application is not authorized to use location services. Due to active restrictions on location services, the user cannot change this status, and may not have personally denied authorization.",
                                                CLAuthorizationStatus.denied:"You have explicitly denied authorization for this application, or location services are disabled in Settings.",
                                                CLAuthorizationStatus.authorizedAlways:"App is Authorized to use location services.",
                                                CLAuthorizationStatus.authorizedWhenInUse:"You have granted authorization to use your location only when the app is visible to you."]
    
    
    var delegate:LocationManagerDelegate? = nil
    
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
    
    
    class var sharedInstance: LocationManager {
        struct Static {
            static let instance: LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    
    fileprivate override init() {
        
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
    
    
    func startUpdatingLocation(){
        initLocationManager()
    }
    
    func stopUpdatingLocation(){
        guard let locationManager = locationManager else {
            return
        }
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
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
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
        
        if ((delegate != nil) && (delegate?.responds(to: #selector(LocationManagerDelegate.locationManagerReceivedError(_:))))!) {
            delegate?.locationManagerReceivedError!(error.localizedDescription as NSString)
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
        
        if (delegate != nil) {
            if ((delegate?.responds(to: #selector(LocationManagerDelegate.locationFoundGetAsString(_:longitude:))))!){
                delegate?.locationFoundGetAsString!(latitudeAsString as NSString,longitude:longitudeAsString as NSString)
            }
            if ((delegate?.responds(to: #selector(LocationManagerDelegate.locationFound(_:longitude:))))!){
                delegate?.locationFound(latitude,longitude:longitude)
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
                    
                    if ((delegate != nil) && (delegate?.responds(to: #selector(LocationManagerDelegate.locationManagerVerboseMessage(_:))))!) {
                        delegate?.locationManagerVerboseMessage!(verbose as NSString)
                    }
                }
                
                if (completionHandler != nil) {
                    completionHandler?(latitude, longitude, locationStatus as String, verbose,nil)
                }
            }
            if ((delegate != nil) && (delegate?.responds(to: #selector(LocationManagerDelegate.locationManagerStatus(_:))))!) {
                delegate?.locationManagerStatus!(locationStatus)
            }
        }
        
    }
    
    
    func reverseGeocodeLocationWithLatLon(latitude: Double, longitude: Double, onReverseGeocodingCompletionHandler: LMReverseGeocodeCompletionHandler) {
        
        let location:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: onReverseGeocodingCompletionHandler)
        
    }
    
    func reverseGeocodeLocationWithCoordinates(_ coord: CLLocation, onReverseGeocodingCompletionHandler: LMReverseGeocodeCompletionHandler) {
        
        self.reverseGeocodingCompletionHandler = onReverseGeocodingCompletionHandler
        
        reverseGocode(coord)
    }
    
    fileprivate func reverseGocode(_ location:CLLocation) {
        
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if (error != nil) {
                self.reverseGeocodingCompletionHandler!(nil, nil, error!.localizedDescription)
            }
            else {
                if let placemark = placemarks?.first {
                    let address = AddressParser()
                    address.parseAppleLocationData(placemark)
                    let addressDict = address.getAddressDictionary()
                    self.reverseGeocodingCompletionHandler!(addressDict, placemark, nil)
                }
                else {
                    self.reverseGeocodingCompletionHandler!(nil, nil, "No Placemarks Found!")
                    return
                }
            }
        })
    }
    
    
    
    func geocodeAddressString(address:NSString, onGeocodingCompletionHandler:LMGeocodeCompletionHandler) {
        self.geocodingCompletionHandler = onGeocodingCompletionHandler
        geoCodeAddress(address)
    }
    
    
    fileprivate func geoCodeAddress(_ address:NSString) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address as String, completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            
            if (error != nil) {
                self.geocodingCompletionHandler!(nil,nil,error!.localizedDescription)
            } else {
                if let placemark = placemarks?.first {
                    let address = AddressParser()
                    address.parseAppleLocationData(placemark)
                    let addressDict = address.getAddressDictionary()
                    self.geocodingCompletionHandler!(addressDict,placemark,nil)
                } else {
                    self.geocodingCompletionHandler!(nil, nil, "invalid address: \(address)")
                }
            }
            
        } as! CLGeocodeCompletionHandler)
        
    }
    
    
    func autocompleteUsingGoogleAddressString(address:NSString, onAutocompleteCompletionHandler:LMAutocompleteCompletionHandler){
        self.autocompleteCompletionHandler = onAutocompleteCompletionHandler
        autocompleteUsignGoogleAddress(address)
    }
    
    func geocodeUsingGoogleAddressString(address:NSString, onGeocodingCompletionHandler:LMGeocodeCompletionHandler){
        self.geocodingCompletionHandler = onGeocodingCompletionHandler
        geoCodeUsignGoogleAddress(address)
    }
    
    fileprivate func autocompleteUsignGoogleAddress(_ address:NSString){

        let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsGeocodeAPIKey") as! String
        var urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&sensor=true&key=\(key)" as NSString
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
        performAutocompleteOperationForURL(urlString, type: GeoCodingType.geocoding)
    }
    
    fileprivate func geoCodeUsignGoogleAddress(_ address:NSString){
        let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsGeocodeAPIKey") as! String
        var urlString = "https://maps.googleapis.com/maps/api/geocode/json?address=\(address)&sensor=true=\(key)" as NSString
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
        performOperationForURL(urlString, type: GeoCodingType.geocoding)
    }
    
    func reverseGeocodeLocationUsingGoogleWithLatLon(latitude:Double, longitude: Double, onReverseGeocodingCompletionHandler: LMReverseGeocodeCompletionHandler) {
        self.reverseGeocodingCompletionHandler = onReverseGeocodingCompletionHandler
        reverseGocodeUsingGoogle(latitude: latitude, longitude: longitude)
    }
    
    func reverseGeocodeLocationUsingGoogleWithCoordinates(_ coord:CLLocation, onReverseGeocodingCompletionHandler: LMReverseGeocodeCompletionHandler) {
        reverseGeocodeLocationUsingGoogleWithLatLon(latitude: coord.coordinate.latitude, longitude: coord.coordinate.longitude, onReverseGeocodingCompletionHandler: onReverseGeocodingCompletionHandler)
    }
    
    fileprivate func reverseGocodeUsingGoogle(latitude:Double, longitude: Double) {
        let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsGeocodeAPIKey") as! String
        var urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&sensor=true\(key)" as NSString
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! as NSString
        performOperationForURL(urlString, type: GeoCodingType.reverseGeocoding)
    }
    
    fileprivate func performAutocompleteOperationForURL(_ urlString: NSString, type:GeoCodingType) {
        
        let url:URL? = URL(string:urlString as String)
        let request:URLRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if (error != nil) {
                self.setCompletionHandler(responseInfo: nil, placemark: nil, error: error!.localizedDescription, type: type)
            } else{
                let kStatus = "status"
                let kOK = "ok"
                let kZeroResults = "ZERO_RESULTS"
                let kAPILimit = "OVER_QUERY_LIMIT"
                let kRequestDenied = "REQUEST_DENIED"
                let kInvalidRequest = "INVALID_REQUEST"
                let kInvalidInput =  "Invalid Input"
                
                //let dataAsString: NSString? = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                let jsonResult: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
                var status = jsonResult.value(forKey: kStatus) as! NSString
                status = status.lowercased as NSString
                
                if (status.isEqual(to: kOK)) {
                    
                    let address = AddressParser()
                    let locationsDict = (jsonResult.value(forKey: "results") as! NSArray)
                    
                    var addressDictArray: [NSDictionary] = []
                    var placemarksArray: [CLPlacemark] = []

                    for locationDict in locationsDict {
                        address.parseGoogleLocationData(locationDict as! NSDictionary)
                        addressDictArray.append(address.getAddressDictionary())
                        placemarksArray.append(address.getPlacemark())
                    }
                    
                    self.setAutoCompletionHandler(responseInfo: addressDictArray, placemark: placemarksArray, error: nil)
                    
                } else if (!status.isEqual(to: kZeroResults) && !status.isEqual(to: kAPILimit) && !status.isEqual(to: kRequestDenied) && !status.isEqual(to: kInvalidRequest)) {
                    self.setAutoCompletionHandler(responseInfo:nil, placemark:nil, error:kInvalidInput)
                } else {
                    //status = (status.componentsSeparatedByString("_") as NSArray).componentsJoinedByString(" ").capitalizedString
                    self.setAutoCompletionHandler(responseInfo:nil, placemark:nil, error:status as String)
                }
            }
        })
        
        task.resume()
        
    }
    
    fileprivate func performOperationForURL(_ urlString: NSString, type:GeoCodingType) {
        
        let url:URL? = URL(string:urlString as String)
        let request:URLRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if (error != nil) {
                self.setCompletionHandler(responseInfo: nil, placemark: nil, error: error!.localizedDescription, type: type)
            } else{
                let kStatus = "status"
                let kOK = "ok"
                let kZeroResults = "ZERO_RESULTS"
                let kAPILimit = "OVER_QUERY_LIMIT"
                let kRequestDenied = "REQUEST_DENIED"
                let kInvalidRequest = "INVALID_REQUEST"
                let kInvalidInput =  "Invalid Input"
                
                //let dataAsString: NSString? = NSString(data: data!, encoding: NSUTF8StringEncoding)
                
                let jsonResult: NSDictionary = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
                var status = jsonResult.value(forKey: kStatus) as! NSString
                status = status.lowercased as NSString
                
                if (status.isEqual(to: kOK)) {
                    
                    let address = AddressParser()
                    let locationDict = (jsonResult.value(forKey: "results") as! NSArray).firstObject as! NSDictionary
                    
                    address.parseGoogleLocationData(locationDict)
                    
                    let addressDict = address.getAddressDictionary()
                    let placemark:CLPlacemark = address.getPlacemark()
                    
                    self.setCompletionHandler(responseInfo: addressDict, placemark: placemark, error: nil, type: type)
                    
                } else if (!status.isEqual(to: kZeroResults) && !status.isEqual(to: kAPILimit) && !status.isEqual(to: kRequestDenied) && !status.isEqual(to: kInvalidRequest)) {
                    self.setCompletionHandler(responseInfo:nil, placemark:nil, error:kInvalidInput, type:type)
                } else {
                    //status = (status.componentsSeparatedByString("_") as NSArray).componentsJoinedByString(" ").capitalizedString
                    self.setCompletionHandler(responseInfo:nil, placemark:nil, error:status as String, type:type)
                }
            }
        })
        
        task.resume()
        
    }
    
    fileprivate func setCompletionHandler(responseInfo: NSDictionary?, placemark:CLPlacemark?, error:String?,type:GeoCodingType) {
        if (type == GeoCodingType.geocoding) {
            self.geocodingCompletionHandler!(responseInfo,placemark,error)
        } else {
            self.reverseGeocodingCompletionHandler!(responseInfo,placemark,error)
        }
    }
    
    fileprivate func setAutoCompletionHandler(responseInfo: [NSDictionary]?, placemark:[CLPlacemark]?, error:String?) {
        self.autocompleteCompletionHandler!(responseInfo, placemark, error)
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

private class AddressParser: NSObject{
    
    fileprivate var latitude = NSString()
    fileprivate var longitude  = NSString()
    fileprivate var streetNumber = NSString()
    fileprivate var route = NSString()
    fileprivate var locality = NSString()
    fileprivate var subLocality = NSString()
    fileprivate var formattedAddress = NSString()
    fileprivate var administrativeArea = NSString()
    fileprivate var administrativeAreaCode = NSString()
    fileprivate var subAdministrativeArea = NSString()
    fileprivate var postalCode = NSString()
    fileprivate var country = NSString()
    fileprivate var subThoroughfare = NSString()
    fileprivate var thoroughfare = NSString()
    fileprivate var ISOcountryCode = NSString()
    fileprivate var state = NSString()
    
    
    override init(){
        super.init()
    }
    
    fileprivate func getAddressDictionary()-> NSDictionary{
        
        let addressDict = NSMutableDictionary()
        
        addressDict.setValue(latitude, forKey: "latitude")
        addressDict.setValue(longitude, forKey: "longitude")
        addressDict.setValue(streetNumber, forKey: "streetNumber")
        addressDict.setValue(locality, forKey: "locality")
        addressDict.setValue(subLocality, forKey: "subLocality")
        addressDict.setValue(administrativeArea, forKey: "administrativeArea")
        addressDict.setValue(postalCode, forKey: "postalCode")
        addressDict.setValue(country, forKey: "country")
        addressDict.setValue(formattedAddress, forKey: "formattedAddress")
        
        return addressDict
    }
    
    
    fileprivate func parseAppleLocationData(_ placemark: CLPlacemark) {
        
        let addressLines = placemark.addressDictionary!["FormattedAddressLines"] as! NSArray
        
        //self.streetNumber = placemark.subThoroughfare ? placemark.subThoroughfare : ""
        self.streetNumber = (placemark.thoroughfare != nil ? placemark.thoroughfare : "")! as NSString
        self.locality = (placemark.locality != nil ? placemark.locality : "")! as NSString
        self.postalCode = (placemark.postalCode != nil ? placemark.postalCode : "")! as NSString
        self.subLocality = (placemark.subLocality != nil ? placemark.subLocality : "")! as NSString
        self.administrativeArea = (placemark.administrativeArea != nil ? placemark.administrativeArea : "")! as NSString
        self.country = (placemark.country != nil ?  placemark.country : "")! as NSString
        self.longitude = placemark.location!.coordinate.longitude.description as NSString;
        self.latitude = placemark.location!.coordinate.latitude.description as NSString
        if (addressLines.count > 0) {
            self.formattedAddress = addressLines.componentsJoined(by: ", ") as NSString
        } else {
            self.formattedAddress = ""
        }
    }
    
    
    fileprivate func parseGoogleLocationData(_ locationDict:NSDictionary) {
        
        let formattedAddrs = locationDict.object(forKey: "formatted_address") as! NSString
        
        let geometry = locationDict.object(forKey: "geometry") as! NSDictionary
        let location = geometry.object(forKey: "location") as! NSDictionary
        let lat = location.object(forKey: "lat") as! Double
        let lng = location.object(forKey: "lng") as! Double
        
        self.latitude = lat.description as NSString
        self.longitude = lng.description as NSString
        
        let addressComponents = locationDict.object(forKey: "address_components") as! NSArray
        
        self.subThoroughfare = component("street_number", inArray: addressComponents, ofType: "long_name")
        self.thoroughfare = component("route", inArray: addressComponents, ofType: "long_name")
        self.streetNumber = self.subThoroughfare
        self.locality = component("locality", inArray: addressComponents, ofType: "long_name")
        self.postalCode = component("postal_code", inArray: addressComponents, ofType: "long_name")
        self.route = component("route", inArray: addressComponents, ofType: "long_name")
        self.subLocality = component("subLocality", inArray: addressComponents, ofType: "long_name")
        self.administrativeArea = component("administrative_area_level_1", inArray: addressComponents, ofType: "long_name")
        self.administrativeAreaCode = component("administrative_area_level_1", inArray: addressComponents, ofType: "short_name")
        self.subAdministrativeArea = component("administrative_area_level_2", inArray: addressComponents, ofType: "long_name")
        self.country =  component("country", inArray: addressComponents, ofType: "long_name")
        self.ISOcountryCode =  component("country", inArray: addressComponents, ofType: "short_name")
        self.formattedAddress = formattedAddrs;
    }
    
    fileprivate func component(_ component:NSString,inArray:NSArray,ofType:NSString) -> NSString{
        let index = inArray.indexOfObject(passingTest:) {obj, idx, stop in
            let objDict:NSDictionary = obj as! NSDictionary
            let types:NSArray = objDict.object(forKey: "types") as! NSArray
            let type = types.firstObject as! NSString
            return type.isEqual(to: component as String)
        }
        
        if (index == NSNotFound) {
            return ""
        }
        
        if (index >= inArray.count) {
            return ""
        }
        
        let type = ((inArray.object(at: index) as! NSDictionary).value(forKey: ofType as String)!) as! NSString
        if (type.length > 0) {
            return type
        }
        return ""
    }
    
    fileprivate func getPlacemark() -> CLPlacemark {
        
        var addressDict = [String : AnyObject]()
        
        let formattedAddressArray = self.formattedAddress.components(separatedBy: ", ") as Array
        
        let kSubAdministrativeArea = "SubAdministrativeArea"
        let kSubLocality           = "SubLocality"
        let kState                 = "State"
        let kStreet                = "Street"
        let kThoroughfare          = "Thoroughfare"
        let kFormattedAddressLines = "FormattedAddressLines"
        let kSubThoroughfare       = "SubThoroughfare"
        let kPostCodeExtension     = "PostCodeExtension"
        let kCity                  = "City"
        let kZIP                   = "ZIP"
        let kCountry               = "Country"
        let kCountryCode           = "CountryCode"
        
        addressDict[kSubAdministrativeArea] = self.subAdministrativeArea
        addressDict[kSubLocality] = self.subLocality as NSString
        addressDict[kState] = self.administrativeAreaCode
        
        addressDict[kStreet] = formattedAddressArray.first! as NSString
        addressDict[kThoroughfare] = self.thoroughfare
        addressDict[kFormattedAddressLines] = formattedAddressArray as AnyObject?
        addressDict[kSubThoroughfare] = self.subThoroughfare
        addressDict[kPostCodeExtension] = "" as AnyObject?
        addressDict[kCity] = self.locality
        
        addressDict[kZIP] = self.postalCode
        addressDict[kCountry] = self.country
        addressDict[kCountryCode] = self.ISOcountryCode
        
        let lat = self.latitude.doubleValue
        let lng = self.longitude.doubleValue
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict as [String : AnyObject]?)
        
        return (placemark as CLPlacemark)
    }
    
}
