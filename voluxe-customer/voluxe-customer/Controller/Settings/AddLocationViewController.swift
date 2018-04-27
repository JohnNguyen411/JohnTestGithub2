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

class AddLocationViewController: VLPresentrViewController, LocationManagerDelegate, UITextFieldDelegate, VLVerticalSearchTextFieldDelegate, PresentrDelegate {
    
    var pickupLocationDelegate: AddLocationDelegate?
    var locationManager = LocationManager.sharedInstance
    
    var presentrDelegate: PresentrDelegate?
    var selectedLocationInfo: NSDictionary?
    var selectedLocationPlacemark: CLPlacemark?
    
    var locationInfoArray: [NSDictionary]?
    var locationPlacemarkArray: [CLPlacemark]?
    
    var autoCompleteCharacterCount = 0
    
    let newLocationTextField = VLVerticalSearchTextField(title: .AddressForPickup, placeholder: .AddressForPickupPlaceholder)
    
    override init(title: String, buttonTitle: String, screenName: String) {
        super.init(title: title, buttonTitle: buttonTitle, screenName: screenName)
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

        bottomButton.isEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
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
        return baseHeight + VLVerticalTextField.height + 50
    }
    
    
    override func onButtonClick() {
        if let pickupLocationDelegate = pickupLocationDelegate, let selectedLocationInfo = selectedLocationInfo, let selectedLocationPlacemark = selectedLocationPlacemark {
            pickupLocationDelegate.onLocationAdded(responseInfo: selectedLocationInfo, placemark: selectedLocationPlacemark)
        }
    }
    
    
    func autocompleteWithText(userText: String){
        selectedLocationInfo = nil
        selectedLocationPlacemark = nil
        self.bottomButton.isEnabled = false

        self.locationManager.autocompleteUsingGoogleAddressString(address: self.newLocationTextField.text as NSString, onAutocompleteCompletionHandler: { (gecodeInfos: [NSDictionary]?, placemarks: [CLPlacemark]?, error: String?) in
            if let _ = error {
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
        
        self.bottomButton.isEnabled = true
        //self.newLocationTextField.textField.resignFirstResponder()
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
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        if let presentrDelegate = presentrDelegate {
            return presentrDelegate.presentrShouldDismiss!(keyboardShowing: keyboardShowing)
        }
        return true
    }
}

// MARK: protocol AddLocationDelegate
protocol AddLocationDelegate: class {
    func onLocationAdded(responseInfo: NSDictionary?, placemark: CLPlacemark?)
    
}
