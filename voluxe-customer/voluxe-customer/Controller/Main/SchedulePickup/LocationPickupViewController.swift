//
//  LocationPickupViewController.swift
//  voluxe-customer
//
//  Created by Giroux, Johan on 11/7/17.
//  Copyright © 2017 Luxe - Volvo Cars. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationPickupViewController: VLPresentrViewController, LocationManagerDelegate, UITextFieldDelegate {
    
    var pickupLocationDelegate: PickupLocationDelegate?
    var locationManager = LocationManager.sharedInstance

    var currentLocationInfo: NSDictionary?
    var currentLocationPlacemark: CLPlacemark?
    
    let newLocationLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.text = (.AddNewLocation as String).uppercased()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let newLocationTextField = VLVerticalTextField(title: .AddressForPickup, placeholder: .AddressForPickupPlaceholder)
    let groupedLabels = VLGroupedLabels(singleChoice: true, topBottomSeparator: true)
    
    override init() {
        super.init()
        newLocationTextField.textField.delegate = self
        newLocationTextField.rightLabel.isHidden = true

        newLocationTextField.setRightButtonText(rightButtonText: (.Add as String).uppercased(), actionBlock: {
            self.addLocation(location: self.newLocationTextField.text)
            self.newLocationTextField.textField.resignFirstResponder()
            self.newLocationTextField.textField.text = ""
            if let pickupLocationDelegate = self.pickupLocationDelegate {
                pickupLocationDelegate.onLocationAdded(newSize: self.groupedLabels.items.count)
            }
        })
        addLocation(location: .YourLocation)
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
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
        groupedLabels.addItem(item: location)
        
        containerView.snp.updateConstraints{ make in
            make.height.equalTo(height())
        }
        
        groupedLabels.snp.updateConstraints{ make in
            make.height.equalTo(groupedLabels.items.count * VLSelectableLabel.height)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        containerView.addSubview(groupedLabels)
        containerView.addSubview(newLocationLabel)
        containerView.addSubview(newLocationTextField)
        
        newLocationTextField.snp.makeConstraints { make in
            make.bottom.equalTo(bottomButton.snp.top).offset(-30)
            make.left.right.equalToSuperview()
            make.height.equalTo(VLVerticalTextField.height)
        }
        
        newLocationLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(newLocationTextField.snp.top)
            make.height.equalTo(25)
        }

        groupedLabels.snp.makeConstraints { make in
            make.bottom.equalTo(newLocationLabel.snp.top).offset(-20)
            make.left.right.equalToSuperview()
            make.height.equalTo(groupedLabels.items.count * VLSelectableLabel.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(groupedLabels.snp.top).offset(-10)
            make.height.equalTo(25)
        }
    }
    
    override func height() -> Int {
        return (groupedLabels.items.count * VLSelectableLabel.height) + VLPresentrViewController.baseHeight + VLVerticalTextField.height + 100
    }
    
    func locationFound(_ latitude: Double, longitude: Double) {
        locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in
            if let reverseGeocodeInfo = reverseGeocodeInfo {
                self.currentLocationInfo = reverseGeocodeInfo
                self.currentLocationPlacemark = placemark
                print("Address found")
                print(reverseGeocodeInfo["formattedAddress"] ?? "")
                DispatchQueue.main.sync {
                    self.bottomButton.isEnabled = true
                }
            }
        }
    }
    
    override func onButtonClick() {
        if let pickupLocationDelegate = pickupLocationDelegate {
            pickupLocationDelegate.onLocationSelected(responseInfo: currentLocationInfo, placemark: currentLocationPlacemark)
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

// MARK: protocol VLGroupedLabelsDelegate
protocol PickupLocationDelegate: class {
    func onLocationAdded(newSize: Int)
    func onLocationSelected(responseInfo: NSDictionary?, placemark: CLPlacemark?)

}
