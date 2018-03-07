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
import RealmSwift

class LocationPickupViewController: VLPresentrViewController, LocationManagerDelegate, UITextFieldDelegate, VLGroupedLabelsDelegate, VLVerticalSearchTextFieldDelegate {
    
    var user: Customer?
    
    var addresses: Results<CustomerAddress>?
    var addressesCount = 0
    var realm : Realm?
    
    var pickupLocationDelegate: PickupLocationDelegate?
    var locationManager = LocationManager.sharedInstance
    
    // current location == user current location
    var currentLocationIndex = -1
    var currentLocationInfo: NSDictionary?
    var currentLocationPlacemark: CLPlacemark?
    
    // selected Location == selected from autocomplete
    var selectedLocationInfo: NSDictionary?
    var selectedLocationPlacemark: CLPlacemark?
    
    // locations displayed in autocomplete
    var locationInfoArray: [NSDictionary]?
    var locationPlacemarkArray: [CLPlacemark]?
    
    var autoCompleteCharacterCount = 0
    
    var selectedIndex = 0
    
    let newLocationLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .luxeGray()
        titleLabel.text = (.AddNewLocation as String).uppercased()
        titleLabel.font = .volvoSansLightBold(size: 12)
        titleLabel.textAlignment = .left
        return titleLabel
    }()
    
    let newLocationTextField = VLVerticalSearchTextField(title: .AddressForPickup, placeholder: .AddressForPickupPlaceholder)
    let groupedLabels = VLGroupedLabels(singleChoice: true, topBottomSeparator: true)
    
    override init() {
        super.init()
        newLocationTextField.textField.autocorrectionType = .no
        newLocationTextField.tableYOffset = -20
        newLocationTextField.tableBottomMargin = 0
        newLocationTextField.maxResultsListHeight = Int(3 * VLVerticalSearchTextField.defaultCellHeight)
        newLocationTextField.delegate = self
        newLocationTextField.textField.accessibilityIdentifier = "newLocationTextField.textField"
        newLocationTextField.textField.delegate = self
        newLocationTextField.rightLabel.isHidden = true
        newLocationTextField.rightLabel.accessibilityIdentifier = "newLocationTextField.rightLabel"
  
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        bottomButton.isEnabled = false
        groupedLabels.delegate = self
        
        user = UserManager.sharedInstance.getCustomer()
        realm = try? Realm()
        if let realm = self.realm, let user = user {
            addresses = realm.objects(CustomerAddress.self).filter("email = %@", user.email ?? "")
            if let addresses = addresses {
                addressesCount = addresses.count
                for address in addresses {
                    addLocation(location: (address.location?.address)!)
                }
            }
        }
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
        
        if let pickupLocationDelegate = self.pickupLocationDelegate {
            pickupLocationDelegate.onLocationAdded(newSize: self.groupedLabels.items.count)
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        groupedLabels.clipsToBounds = true
        
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
    
    func autocompleteWithText(userText: String){
        selectedLocationInfo = nil
        selectedLocationPlacemark = nil
        self.bottomButton.isEnabled = false
        
        self.locationManager.autocompleteUsingGoogleAddressString(address: self.newLocationTextField.text as NSString, onAutocompleteCompletionHandler: { (gecodeInfos: [NSDictionary]?, placemarks: [CLPlacemark]?, error: String?) in
            if let error = error {
                DispatchQueue.main.sync {
                    
                    self.newLocationTextField.text = userText
                    self.autoCompleteCharacterCount = 0
                }
                
            } else if let gecodeInfos = gecodeInfos {
                
                self.locationInfoArray = gecodeInfos
                self.locationPlacemarkArray = placemarks
                
                var formattedAddress: [String] = []
                for gecodeInfo in gecodeInfos {
                    formattedAddress.append(gecodeInfo["formattedAddress"] as! String)
                }
                
                DispatchQueue.main.sync {
                    self.newLocationTextField.filteredStrings(formattedAddress)
                }
            }
        })
    }
    
    func locationFound(_ latitude: Double, longitude: Double) {
        locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude) { (reverseGeocodeInfo, placemark, error) -> Void in
            if let reverseGeocodeInfo = reverseGeocodeInfo {
                self.currentLocationInfo = reverseGeocodeInfo
                self.currentLocationPlacemark = placemark
                
                Logger.print("Address found")
                Logger.print(reverseGeocodeInfo["formattedAddress"] ?? "")
                DispatchQueue.main.sync {
                    self.addLocation(location: .YourLocation)
                    self.currentLocationIndex = self.groupedLabels.items.count - 1
                    self.bottomButton.isEnabled = true
                }
            }
        }
    }
    
    override func onButtonClick() {
        if let pickupLocationDelegate = pickupLocationDelegate {
            if selectedIndex == currentLocationIndex {
                
                guard let currentLocationInfo = currentLocationInfo, let currentLocationPlacemark = currentLocationPlacemark else {
                    return
                }
                // add location to realm
                var customerAddress = CustomerAddress()
                let addressString: String = currentLocationInfo["formattedAddress"] as! String
                
                customerAddress.location = Location(name: addressString, latitude: nil, longitude: nil, location: currentLocationPlacemark.location?.coordinate)
                customerAddress.createdAt = Date()
                customerAddress.volvoCustomerId = user!.email
                
                if let realm = self.realm {
                    // "email = %@", user.email ?? ""
                    let existingAddress = realm.objects(CustomerAddress.self).filter("location.address = %@ AND email = %@", addressString, user!.email ?? "").first
                    if existingAddress == nil {
                        try? realm.write {
                            realm.add(customerAddress)
                            if let addresses = addresses {
                                addressesCount = addresses.count
                            }
                        }
                    } else {
                        customerAddress = existingAddress!
                    }
                }
                
                pickupLocationDelegate.onLocationSelected(customerAddress: customerAddress)
            } else {
                var realmSelectedIndex = selectedIndex
                if currentLocationIndex > -1 {
                    if currentLocationIndex < selectedIndex {
                        realmSelectedIndex = selectedIndex - 1
                    }
                }
                
                if let addresses = addresses {
                    pickupLocationDelegate.onLocationSelected(customerAddress: addresses[realmSelectedIndex])
                }
            }
            
        }
    }
    
    // MARK: protocol UITextFieldDelegate
    
    func onAutocompleteSelected(selectedIndex: Int) {
        
        newLocationTextField.closeAutocomplete()
        
        guard let locationPlacemarkArray = locationPlacemarkArray, let locationInfoArray = locationInfoArray else {
            return
        }
        
        if selectedIndex > locationPlacemarkArray.count {
            return
        }
        
        selectedLocationInfo = locationInfoArray[selectedIndex]
        selectedLocationPlacemark = locationPlacemarkArray[selectedIndex]
        
        guard let selectedLocationInfo = selectedLocationInfo, let selectedLocationPlacemark = selectedLocationPlacemark else {
            return
        }
        
        
        // add location to realm
        let customerAddress = CustomerAddress()
        
        customerAddress.location = Location(name: selectedLocationInfo["formattedAddress"] as? String, latitude: nil, longitude: nil, location: selectedLocationPlacemark.location?.coordinate)
        customerAddress.createdAt = Date()
        customerAddress.volvoCustomerId = user!.email
        
        if let realm = self.realm {
            try? realm.write {
                realm.add(customerAddress)
                if let addresses = addresses {
                    addressesCount = addresses.count
                }
                self.addLocation(location: selectedLocationInfo["formattedAddress"] as! String)
                self.newLocationTextField.clearResults()
                self.resetValues()
                self.newLocationTextField.textField.resignFirstResponder()
            }
        }
        
        self.bottomButton.isEnabled = true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string) // 2
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 { // 3 when a user clears the textField
            resetValues()
        } else {
            autocompleteWithText(userText: subString) //4
        }
        return true
    }
    
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized //5
        return formatted
    }
    
    func resetValues() {
        autoCompleteCharacterCount = 0
        self.newLocationTextField.textField.text = ""
    }
    
    // MARK: protocol VLGroupedLabelsDelegate
    func onSelectionChanged(selected: Bool, selectedIndex: Int) {
        if selected {
            self.selectedIndex = selectedIndex
        }
        if self.selectedIndex > -1 {
            self.bottomButton.isEnabled = true
        }
    }
    
}

// MARK: protocol VLGroupedLabelsDelegate
protocol PickupLocationDelegate: class {
    func onLocationAdded(newSize: Int)
    func onLocationSelected(customerAddress: CustomerAddress)
    
}
