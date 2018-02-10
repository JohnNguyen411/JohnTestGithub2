//
//  AddLocationViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 2/9/18.
//  Copyright © 2018 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddLocationViewController: VLPresentrViewController, LocationManagerDelegate, UITextFieldDelegate {
    
    var pickupLocationDelegate: AddLocationDelegate?
    var locationManager = LocationManager.sharedInstance
    
    var currentLocationInfo: NSDictionary?
    var currentLocationPlacemark: CLPlacemark?
    
    var locationInfoArray: [NSDictionary] = []
    var locationPlacemarkArray: [CLPlacemark] = []
    
    let newLocationTextField = VLVerticalTextField(title: .AddressForPickup, placeholder: .AddressForPickupPlaceholder)
    
    override init() {
        super.init()
        newLocationTextField.textField.accessibilityIdentifier = "newLocationTextField.textField"
        newLocationTextField.textField.delegate = self
        newLocationTextField.rightLabel.isHidden = true
        newLocationTextField.rightLabel.accessibilityIdentifier = "newLocationTextField.rightLabel"
        
        newLocationTextField.setRightButtonText(rightButtonText: (.Add as String).uppercased(), actionBlock: {
            // look for real address
            self.locationManager.geocodeUsingGoogleAddressString(address: self.newLocationTextField.text as NSString, onGeocodingCompletionHandler: { (gecodeInfo: NSDictionary?, placemark: CLPlacemark?, error: String?) in
                if let error = error {
                } else if let gecodeInfo = gecodeInfo {
                    
                    self.locationInfoArray.append(gecodeInfo)
                    self.locationPlacemarkArray.append(placemark!)
                    
                    let formattedAddress = gecodeInfo["formattedAddress"] as! String
                    
                    DispatchQueue.main.sync {
                        self.bottomButton.isEnabled = true
                        self.addLocation(location: formattedAddress)
                        self.newLocationTextField.textField.resignFirstResponder()
                        self.newLocationTextField.textField.text = ""
                    }
                }
                
            })
        })
        //addLocation(location: .YourLocation)
        locationManager.delegate = self
        //locationManager.startUpdatingLocation()
        bottomButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
    }
    
    func addLocation(location: String) {
        onButtonClick()
    }
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubview(newLocationTextField)
        
        newLocationTextField.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(newLocationTextField.snp.top).offset(-10)
            make.height.equalTo(25)
        }
    }
    
    override func height() -> Int {
        return VLPresentrViewController.baseHeight + VLVerticalTextField.height + 100
    }
    
    func locationFound(_ latitude: Double, longitude: Double) {
        locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in
            if let reverseGeocodeInfo = reverseGeocodeInfo {
                self.currentLocationInfo = reverseGeocodeInfo
                self.currentLocationPlacemark = placemark
                
                self.locationInfoArray.append(reverseGeocodeInfo)
                self.locationPlacemarkArray.append(placemark!)
                
                Logger.print("Address found")
                Logger.print(reverseGeocodeInfo["formattedAddress"] ?? "")
                DispatchQueue.main.sync {
                    self.addLocation(location: .YourLocation)
                    self.bottomButton.isEnabled = true
                }
            }
        }
    }
    
    override func onButtonClick() {
        if let pickupLocationDelegate = pickupLocationDelegate {
            pickupLocationDelegate.onLocationAdded(responseInfo: locationInfoArray[0], placemark: locationPlacemarkArray[0])
        }
    }
    
    // MARK: protocol UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string.count == 0 {
            newLocationTextField.rightLabel.isHidden = true
        } else {
            newLocationTextField.rightLabel.isHidden = false
        }
        
        return true
    }
    
}

// MARK: protocol AddLocationDelegate
protocol AddLocationDelegate: class {
    func onLocationAdded(responseInfo: NSDictionary?, placemark: CLPlacemark?)
    
}
